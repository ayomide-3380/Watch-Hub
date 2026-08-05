import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/order.dart';
import '../models/watch.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];
  final List<Order> _allOrders = []; // admin-only: every order, every user
  bool _isLoading = false;
  String? _errorMessage;

  List<Order> get orders => List.unmodifiable(_orders);
  List<Order> get allOrders => List.unmodifiable(_allOrders);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Loads this user's order history from the backend.
  Future<void> fetchOrders(String userId, List<Watch> allWatches) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('${ApiConfig.baseUrl}/orders/$userId'));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = jsonDecode(response.body);
        _orders
          ..clear()
          ..addAll(data.map((raw) => Order.fromJson(raw, allWatches)))
          ..sort((a, b) => b.orderDate.compareTo(a.orderDate));
      }
    } catch (e) {
      debugPrint('Fetch Orders Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Admin-only: loads every order from every customer, for the admin
  /// dashboard's Customer Orders tab. Kept separate from `orders` (the
  /// signed-in user's own history) so a regular user's order screen never
  /// accidentally shows other people's orders.
  Future<void> fetchAllOrdersForAdmin(List<Watch> allWatches) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('${ApiConfig.baseUrl}/orders/all'));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = jsonDecode(response.body);
        _allOrders
          ..clear()
          ..addAll(data.map((raw) => Order.fromJson(raw, allWatches)))
          ..sort((a, b) => b.orderDate.compareTo(a.orderDate));
      }
    } catch (e) {
      debugPrint('Fetch All Orders Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Checks out the signed-in user's current cart. The backend rebuilds the
  /// order from whatever is in the user's cart_items table server-side, so
  /// the cart must already be persisted (see CartProvider) before calling
  /// this. Returns the created Order, or null if checkout failed.
  Future<Order?> checkout({
    required String userId,
    required String shippingAddress,
    required String paymentMethod,
    required double discountAmount,
    required List<Watch> allWatches,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/orders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'shippingAddress': shippingAddress,
          'paymentMethod': paymentMethod,
          'discountAmount': discountAmount,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final order = Order.fromJson(jsonDecode(response.body), allWatches);
        _orders.insert(0, order);
        return order;
      } else {
        _errorMessage = response.body.replaceAll('"', '');
        return null;
      }
    } catch (e) {
      debugPrint('Checkout Error: $e');
      _errorMessage = 'Could not connect to server';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Admin status update.
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    final adminIndex = _allOrders.indexWhere((o) => o.id == orderId);
    if (index < 0 && adminIndex < 0) return;

    final previousStatus =
        index >= 0 ? _orders[index].status : _allOrders[adminIndex].status;
    if (index >= 0) _orders[index].status = newStatus; // optimistic update
    if (adminIndex >= 0) _allOrders[adminIndex].status = newStatus;
    notifyListeners();

    try {
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/orders/$orderId/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': orderStatusToString(newStatus)}),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        if (index >= 0) _orders[index].status = previousStatus; // revert
        if (adminIndex >= 0) _allOrders[adminIndex].status = previousStatus;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Update Order Status Error: $e');
      if (index >= 0) _orders[index].status = previousStatus;
      if (adminIndex >= 0) _allOrders[adminIndex].status = previousStatus;
      notifyListeners();
    }
  }

  void reset() {
    _orders.clear();
    _allOrders.clear();
    _errorMessage = null;
    notifyListeners();
  }
}