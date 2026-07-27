import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/mock_data.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = List.from(MockData.sampleOrders);

  List<Order> get orders => List.unmodifiable(_orders);

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Order createOrder({
    required List<CartItem> items,
    required double subtotal,
    required double tax,
    required double shippingFee,
    required double discount,
    required double totalAmount,
    required String shippingAddress,
    required String paymentMethod,
  }) {
    final newOrder = Order(
      id: 'WH-${(1000 + _orders.length * 423)}-2026',
      orderDate: DateTime.now(),
      items: List.from(items),
      subtotal: subtotal,
      tax: tax,
      shippingFee: shippingFee,
      discount: discount,
      totalAmount: totalAmount,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      status: OrderStatus.placed,
      trackingSteps: [
        TrackingStep(
          title: 'Order Placed & Payment Verified',
          description: 'Payment authorized via $paymentMethod.',
          timestamp: DateTime.now(),
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Master Horologist Inspection',
          description: 'Scheduled for precision timing test & security seal.',
          timestamp: DateTime.now().add(const Duration(hours: 4)),
          isCompleted: false,
        ),
        TrackingStep(
          title: 'Dispatched with Armored Courier',
          description: 'Express Overnight Delivery.',
          timestamp: DateTime.now().add(const Duration(hours: 18)),
          isCompleted: false,
        ),
        TrackingStep(
          title: 'Out for Delivery',
          description: 'Courier assigned.',
          timestamp: DateTime.now().add(const Duration(hours: 30)),
          isCompleted: false,
        ),
        TrackingStep(
          title: 'Delivered',
          description: 'Recipient signature required.',
          timestamp: DateTime.now().add(const Duration(hours: 36)),
          isCompleted: false,
        ),
      ],
    );

    _orders.insert(0, newOrder);
    notifyListeners();
    return newOrder;
  }

  // Admin status update
  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      _orders[index].status = newStatus;
      notifyListeners();
    }
  }
}
