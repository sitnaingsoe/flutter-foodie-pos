import 'package:flutter/material.dart';
import 'package:test_1/api_response/api_response.dart';
import 'package:test_1/models/product_model.dart';
import 'package:test_1/services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();
  final List<Product> _products = [];

  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String selectedCategory = "all";

  int limit = 10;
  int skip = 0;
  bool hasMore = true;
  bool isLoadingMore = false;

  Future<void> fetchProducts() async {
    if (isLoadingMore || !hasMore) return;

    if (_products.isEmpty) {
      _isLoading = true;
    } else {
      isLoadingMore = true;
    }
    notifyListeners();

    final ApiResponse<List<Product>> response = await _service.getProducts(
      limit: limit,
      skip: skip,
    );

    if (response.success == true && response.data != null) {
      final newProducts = response.data!;
      _products.addAll(newProducts);

      if (newProducts.isEmpty) {
        hasMore = false;
      } else {
        _products.addAll(newProducts);
        skip += limit;
      }
    } else {
      _error = response.message;
    }
    _isLoading = false;
    isLoadingMore = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
