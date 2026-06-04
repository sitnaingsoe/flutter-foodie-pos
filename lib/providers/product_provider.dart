import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_1/api_response/api_response.dart';
import 'package:test_1/models/product_model.dart';
import 'package:test_1/services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  List<Product> _products = [];

  bool _isLoading = true;
  String? _error;

  String _searchQuery = '';
  String _selectedCategory = 'all';

  bool _isSearching = false;
  Timer? _searchTimer;

  int limit = 10;
  int skip = 0;
  bool hasMore = true;
  bool isLoadingMore = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;

  String get selectedCategory => _selectedCategory;

  bool get isSearchEmpty => _searchQuery.isNotEmpty && filteredProducts.isEmpty;

  void bottomLoader() {
    isLoadingMore = true;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    if (isLoadingMore || !hasMore) return;

    if (_products.isEmpty) {
      _isLoading = true;
    }

    try {
      ApiResponse<List<Product>> response;

      if (_selectedCategory == 'all') {
        response = await _service.getProducts(limit: limit, skip: skip);
      } else {
        response = await _service.getProductsByCategory(
          category: _selectedCategory,
          limit: limit,
          skip: skip,
        );
      }

      if (response.success == true && response.data != null) {
        final newProducts = response.data!;

        if (newProducts.isEmpty) {
          hasMore = false;
        } else {
          _products.addAll(newProducts);
          skip += limit;
        }
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  List<Product> get filteredProducts {
    List<Product> result = _products;

    if (_selectedCategory != 'all') {
      result = result.where((product) {
        return product.category == _selectedCategory;
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      result = result.where((product) {
        return product.title.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return result;
  }

  void searchProducts(String query) {
    _searchQuery = query;

    _isSearching = true;
    notifyListeners();

    _searchTimer?.cancel();

    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      _isSearching = false;
      notifyListeners();
    });
  }

  void clearSearch() {
    _searchQuery = '';
    _isSearching = false;
    notifyListeners();
  }

  Future<void> setCategory(String category) async {
    _selectedCategory = category;
    _products.clear();
    skip = 0;
    hasMore = true;

    notifyListeners();

    await fetchProducts();
  }

  Future<void> refreshProducts() async {
    _products.clear();
    skip = 0;
    hasMore = true;

    notifyListeners();

    await fetchProducts();
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }
}
