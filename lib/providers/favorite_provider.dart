import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavoriteProvider extends ChangeNotifier {
  
  final Box<int> _favoriteBox = Hive.box<int>('favorites');

  List<int> get favoriteIds => _favoriteBox.values.toList();

  bool isFavorite(int productId) {
    return _favoriteBox.containsKey(productId);
  }

  void toggleFavorite(int productId) {
    if (_favoriteBox.containsKey(productId)) {
      _favoriteBox.delete(productId);
    } else {
      _favoriteBox.put(productId, productId);
    }
    notifyListeners();
  }
}
