import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CartProvider extends ChangeNotifier {
  final Box<int> _cartBox = Hive.box<int>('cart');

  int get totalItemcount => _cartBox.length;

  int get totalQuantity {
    return _cartBox.values.fold(0, (sum, qty) => sum + qty);
  }

  Map<int, int> get cartItems {
    return _cartBox.toMap().cast<int, int>();
  }

  bool isInCart(int productId) {
    return _cartBox.containsKey(productId);
  }

  int quantity(int productId) {
    return _cartBox.get(productId) ?? 0;
  }

  bool addToCart(int productId) {
    if (_cartBox.containsKey(productId)) {
      return false;
    }
    _cartBox.put(productId, 1);
    notifyListeners();
    return true;
  }

  void increaseQty(int productId) {
    final current = _cartBox.get(productId) ?? 0;
    _cartBox.put(productId, current + 1);
    notifyListeners();
  }

  void decreaseQty(int productId) {
    final current = _cartBox.get(productId) ?? 0;
    if (current <= 1) {
      _cartBox.delete(productId);
    } else {
      _cartBox.put(productId, current - 1);
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    _cartBox.delete(productId);
    notifyListeners();
  }

  void clearCart() {
    _cartBox.clear();
    notifyListeners();
  }

  double totalPrice(List products) {
    double total = 0;

    for (final entry in _cartBox.toMap().entries) {
      final productId = entry.key;
      final qty = entry.value;
      final matched = products.where((p) => p.id == productId);
      if (matched.isNotEmpty) {
        total += matched.first.price * qty;
      }
    }

    return total;
  }
}
