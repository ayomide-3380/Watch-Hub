import 'cart_item.dart';

enum OrderStatus {
  placed,
  processing,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
}

class TrackingStep {
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isCompleted;

  TrackingStep({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.isCompleted,
  });
}

class Order {
  final String id;
  final DateTime orderDate;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double shippingFee;
  final double discount;
  final double totalAmount;
  final String shippingAddress;
  final String paymentMethod;
  OrderStatus status;
  final List<TrackingStep> trackingSteps;

  Order({
    required this.id,
    required this.orderDate,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shippingFee,
    this.discount = 0.0,
    required this.totalAmount,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.status,
    required this.trackingSteps,
  });

  String get statusDisplay {
    switch (status) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.processing:
        return 'In Assembly & Inspection';
      case OrderStatus.shipped:
        return 'Dispatched / In Transit';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}
