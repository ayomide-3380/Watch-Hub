import 'cart_item.dart';
import 'watch.dart';

enum OrderStatus {
  placed,
  processing,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
}

OrderStatus orderStatusFromString(String? raw) {
  switch ((raw ?? '').toUpperCase()) {
    case 'PROCESSING':
      return OrderStatus.processing;
    case 'SHIPPED':
      return OrderStatus.shipped;
    case 'OUT_FOR_DELIVERY':
      return OrderStatus.outForDelivery;
    case 'DELIVERED':
      return OrderStatus.delivered;
    case 'CANCELLED':
      return OrderStatus.cancelled;
    case 'PLACED':
    default:
      return OrderStatus.placed;
  }
}

String orderStatusToString(OrderStatus status) {
  switch (status) {
    case OrderStatus.placed:
      return 'PLACED';
    case OrderStatus.processing:
      return 'PROCESSING';
    case OrderStatus.shipped:
      return 'SHIPPED';
    case OrderStatus.outForDelivery:
      return 'OUT_FOR_DELIVERY';
    case OrderStatus.delivered:
      return 'DELIVERED';
    case OrderStatus.cancelled:
      return 'CANCELLED';
  }
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
  });

  /// Always derived from the current status, so it updates automatically
  /// whenever [status] changes (e.g. via an admin update).
  List<TrackingStep> get trackingSteps =>
      buildTrackingSteps(status, orderDate, paymentMethod);

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

  /// Builds the tracking timeline shown in the UI. The backend doesn't
  /// persist per-step tracking events, so this derives a reasonable
  /// timeline from the order's current status and placement time.
  static List<TrackingStep> buildTrackingSteps(
      OrderStatus status, DateTime orderDate, String paymentMethod) {
    const stepOrder = [
      OrderStatus.placed,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];
    final currentIndex =
        stepOrder.contains(status) ? stepOrder.indexOf(status) : 0;

    final titles = [
      'Order Placed & Payment Verified',
      'Master Horologist Inspection',
      'Dispatched with Armored Courier',
      'Out for Delivery',
      'Delivered',
    ];
    final descriptions = [
      'Payment authorized via $paymentMethod.',
      'Scheduled for precision timing test & security seal.',
      'Express Overnight Delivery.',
      'Courier assigned.',
      'Recipient signature required.',
    ];
    final hourOffsets = [0, 4, 18, 30, 36];

    return List.generate(titles.length, (i) {
      return TrackingStep(
        title: titles[i],
        description: descriptions[i],
        timestamp: orderDate.add(Duration(hours: hourOffsets[i])),
        isCompleted: i <= currentIndex && status != OrderStatus.cancelled,
      );
    });
  }

  factory Order.fromJson(Map<String, dynamic> json, List<Watch> allWatches) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];

    final items = itemsJson.map<CartItem>((raw) {
      Watch? watch;
      try {
        watch = allWatches.firstWhere((w) => w.id == raw['watchId']);
      } catch (_) {
        watch = null;
      }
      // Fall back to a minimal Watch built from the order snapshot if the
      // catalog item was later removed or isn't loaded.
      watch ??= Watch(
        id: raw['watchId'] as String? ?? '',
        title: raw['watchTitle'] as String? ?? 'Unknown Watch',
        brand: '',
        price: (raw['watchPrice'] as num?)?.toDouble() ?? 0.0,
        rating: 0,
        reviewCount: 0,
        imageUrls: const [
          'https://images.unsplash.com/photo-1524805444758-089113d48a6d?auto=format&fit=crop&q=80&w=400'
        ],
        category: '',
        type: '',
        description: '',
        specifications: const {},
        availableColors: [raw['selectedColor'] as String? ?? 'Default'],
        availableStraps: [raw['selectedStrap'] as String? ?? 'Default'],
        stockCount: 0,
      );

      return CartItem(
        id: raw['id'] as String?,
        watch: watch,
        selectedColor:
            raw['selectedColor'] as String? ?? watch.availableColors.first,
        selectedStrap:
            raw['selectedStrap'] as String? ?? watch.availableStraps.first,
        quantity: (raw['quantity'] as num?)?.toInt() ?? 1,
      );
    }).toList();

    final orderDate =
        DateTime.tryParse(json['orderDate'] as String? ?? '') ??
            DateTime.now();
    final status = orderStatusFromString(json['status'] as String?);
    final paymentMethod = json['paymentMethod'] as String? ?? '';

    return Order(
      id: json['id'] as String? ?? '',
      orderDate: orderDate,
      items: items,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      shippingFee: (json['shippingFee'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      shippingAddress: json['shippingAddress'] as String? ?? '',
      paymentMethod: paymentMethod,
      status: status,
    );
  }
}