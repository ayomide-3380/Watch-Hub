import 'watch.dart';

class CartItem {
  final String? id; // backend cart_item / order_item id, null until persisted
  final Watch watch;
  final String selectedColor;
  final String selectedStrap;
  int quantity;

  CartItem({
    this.id,
    required this.watch,
    required this.selectedColor,
    required this.selectedStrap,
    this.quantity = 1,
  });

  double get totalPrice => watch.price * quantity;

  CartItem copyWith({
    String? id,
    Watch? watch,
    String? selectedColor,
    String? selectedStrap,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      watch: watch ?? this.watch,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedStrap: selectedStrap ?? this.selectedStrap,
      quantity: quantity ?? this.quantity,
    );
  }
}