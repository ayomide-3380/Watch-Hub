import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/watch.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  String? _appliedPromoCode;
  double _discountPercentage = 0.0;

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  String? get appliedPromoCode => _appliedPromoCode;

  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discountAmount => subtotal * _discountPercentage;

  double get tax => (subtotal - discountAmount) * 0.08; // 8% Tax

  double get shippingFee => subtotal > 10000 || _items.isEmpty ? 0.0 : 150.0;

  double get grandTotal => subtotal - discountAmount + tax + shippingFee;

  void addToCart(Watch watch, {String? color, String? strap, int quantity = 1}) {
    final selectedColor = color ?? watch.availableColors.first;
    final selectedStrap = strap ?? watch.availableStraps.first;

    final existingIndex = _items.indexWhere((item) =>
        item.watch.id == watch.id &&
        item.selectedColor == selectedColor &&
        item.selectedStrap == selectedStrap);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        watch: watch,
        selectedColor: selectedColor,
        selectedStrap: selectedStrap,
        quantity: quantity,
      ));
    }
    notifyListeners();
  }

  void updateQuantity(CartItem item, int newQuantity) {
    if (newQuantity <= 0) {
      _items.remove(item);
    } else {
      item.quantity = newQuantity;
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
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

  void clearCart() {
    _items.clear();
    _appliedPromoCode = null;
    _discountPercentage = 0.0;
    notifyListeners();
  }
}
