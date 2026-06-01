import 'package:flutter/material.dart';
import 'package:test_1/models/cartitem_model.dart';
import 'package:test_1/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  // ✅ REAL CART STORAGE
  final List<CartItem> _items = [];

  // ✅ SAFE GETTER
  List<CartItem> get items => _items;

  // =========================
  // ADD TO CART
  // =========================
  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }

    notifyListeners();
  }
  // =========================
  // REMOVE FROM CART
  // =========================
  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);

    notifyListeners();
  }

  // =========================
  // INCREASE QTY
  // =========================
  void increaseQty(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  // =========================
  // DECREASE QTY
  // =========================
  void decreaseQty(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }

      notifyListeners();
    }
  }

  // =========================
  // TOTAL ITEMS
  // =========================
  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // =========================
  // TOTAL PRICE
  // =========================
  // double get totalPrice {
  //   return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  // }
  // =========================
  // CLEAR CART
  // =========================
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
