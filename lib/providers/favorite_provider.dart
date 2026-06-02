import 'package:flutter/material.dart';
import 'package:test_1/models/product_model.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Product> _favorites = [];

  List<Product> get favorites => _favorites;

  bool isFavorite(int productId) {
    return _favorites.any((item) => item.id == productId);
  }

  bool addToFavorite(Product product) {
    if (isFavorite(product.id)) {
      return false;
    }
    _favorites.add(product);
    notifyListeners();

    return true;
  }

  void removeFromFavorites(Product product) {
    if (isFavorite(product.id)) {
      //_items.removeWhere((item) => item.product.id == product.id);
      _favorites.removeWhere((item) => item.id == product.id);
    }
    notifyListeners();
  }
}
