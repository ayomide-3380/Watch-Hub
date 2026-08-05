import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/cart_item.dart';
import '../models/watch.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  String? _appliedPromoCode;
  double _discountPercentage = 0.0;
  bool _isLoading = false;
  String? _userId;

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  String? get appliedPromoCode => _appliedPromoCode;
  double get discountPercentage => _discountPercentage;
  bool get isLoading => _isLoading;

  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discountAmount => subtotal * _discountPercentage;

  double get tax => (subtotal - discountAmount) * 0.08; // 8% Tax

  double get shippingFee => subtotal > 10000 || _items.isEmpty ? 0.0 : 150.0;

  double get grandTotal => subtotal - discountAmount + tax + shippingFee;

  /// Loads the signed-in user's cart from the backend. [allWatches] is the
  /// currently loaded catalog, used to resolve each cart row's watchId into
  /// a full Watch object (the backend only stores the id).
  Future<void> loadCart(String userId, List<Watch> allWatches) async {
    _userId = userId;
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('${ApiConfig.baseUrl}/cart/$userId'));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = jsonDecode(response.body);
        _items.clear();

        for (final raw in data) {
          Watch? watch;
          try {
            watch = allWatches.firstWhere((w) => w.id == raw['watchId']);
          } catch (_) {
            watch = null; // watch no longer exists in catalog, skip
          }
          if (watch == null) continue;

          _items.add(CartItem(
            id: raw['id'] as String?,
            watch: watch,
            selectedColor:
                raw['selectedColor'] as String? ?? watch.availableColors.first,
            selectedStrap:
                raw['selectedStrap'] as String? ?? watch.availableStraps.first,
            quantity: (raw['quantity'] as num?)?.toInt() ?? 1,
          ));
        }
      }
    } catch (e) {
      debugPrint('Load Cart Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(Watch watch,
      {String? color, String? strap, int quantity = 1}) async {
    final selectedColor = color ?? watch.availableColors.first;
    final selectedStrap = strap ?? watch.availableStraps.first;

    if (_userId == null) {
      debugPrint('Add to Cart Error: no signed-in user');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/cart'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': _userId,
          'watchId': watch.id,
          'selectedColor': selectedColor,
          'selectedStrap': selectedStrap,
          'quantity': quantity,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final raw = jsonDecode(response.body);
        final id = raw['id'] as String?;
        final serverQuantity = (raw['quantity'] as num?)?.toInt() ?? quantity;

        final existingIndex = _items.indexWhere((item) => item.id == id);
        final updatedItem = CartItem(
          id: id,
          watch: watch,
          selectedColor: selectedColor,
          selectedStrap: selectedStrap,
          quantity: serverQuantity,
        );

        if (existingIndex >= 0) {
          _items[existingIndex] = updatedItem;
        } else {
          _items.add(updatedItem);
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Add to Cart Error: $e');
    }
  }

  Future<void> updateQuantity(CartItem item, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeItem(item);
      return;
    }

    if (item.id == null) return;

    try {
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/cart/${item.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'quantity': newQuantity}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        item.quantity = newQuantity;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Update Quantity Error: $e');
    }
  }

  Future<void> removeItem(CartItem item) async {
    if (item.id != null) {
      try {
        await http.delete(Uri.parse('${ApiConfig.baseUrl}/cart/${item.id}'));
      } catch (e) {
        debugPrint('Remove Item Error: $e');
      }
    }
    _items.remove(item);
    notifyListeners();
  }

  bool applyPromoCode(String code) {
    final upper = code.trim().toUpperCase();
    if (upper == 'WATCHHUB10' || upper == 'LUXURY10') {
      _appliedPromoCode = upper;
      _discountPercentage = 0.10;
      notifyListeners();
      return true;
    } else if (upper == 'VIP20') {
      _appliedPromoCode = upper;
      _discountPercentage = 0.20;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromoCode() {
    _appliedPromoCode = null;
    _discountPercentage = 0.0;
    notifyListeners();
  }

  Future<void> clearCart() async {
    if (_userId != null) {
      try {
        await http
            .delete(Uri.parse('${ApiConfig.baseUrl}/cart/clear/$_userId'));
      } catch (e) {
        debugPrint('Clear Cart Error: $e');
      }
    }
    _items.clear();
    _appliedPromoCode = null;
    _discountPercentage = 0.0;
    notifyListeners();
  }

  /// Called on logout so the next user doesn't see a stale cart.
  void reset() {
    _items.clear();
    _appliedPromoCode = null;
    _discountPercentage = 0.0;
    _userId = null;
    notifyListeners();
  }
}