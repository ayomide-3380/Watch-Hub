import 'watch.dart';

class CartItem {
  final Watch watch;
  final String selectedColor;
  final String selectedStrap;
  int quantity;

  CartItem({
    required this.watch,
    required this.selectedColor,
    required this.selectedStrap,
    this.quantity = 1,
  });

  double get totalPrice => watch.price * quantity;

  CartItem copyWith({
    Watch? watch,
    String? selectedColor,
    String? selectedStrap,
    int? quantity,
  }) {
    return CartItem(
      watch: watch ?? this.watch,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedStrap: selectedStrap ?? this.selectedStrap,
      quantity: quantity ?? this.quantity,
    );
  }
}
