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
  

  String get searchQuery => _searchQuery;
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String _selectedCategory = "all";
  bool get isSearchEmpty => _searchQuery.isNotEmpty && _products.isEmpty;

  String get selectedCategory => _selectedCategory;

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

    try {
      ApiResponse<List<Product>> response;

      if (_selectedCategory == "all") {
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
      e.toString();
    }
    _isLoading = false;
    isLoadingMore = false;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    List<Product> result = _products;
    if (_selectedCategory != "all") {
      result = result.where((product) {
        return product.category == _selectedCategory;
      }).toList();
    }
    if (_searchQuery.isNotEmpty) {
      result = result.where((product) {
        final title = product.title.toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query);
      }).toList();
    }
    return result;
  }

  void searchProducts(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Future<void> searchProducts(String query) async {
  //   _searchQuery = query;
  //   _isSearching = true;
  //   _products = [];
  //   skip = 0;
  //   hasMore = true;
  //   notifyListeners();
  //   try {
  //     final response = await _service.searchProducts(
  //       query: query,
  //       limit: limit,
  //       skip: 0,
  //     );
  //     if (response.success == true && response.data != null) {
  //       _products = response.data!;
  //       skip += limit;
  //     } else {
  //       _error = response.message;
  //     }
  //   } catch (e) {
  //     _error = e.toString();
  //   }
  // }

  Future<void> setCategory(String category) async {
    _selectedCategory = category;
    _products = [];
    skip = 0;
    hasMore = true;

    notifyListeners();
    await fetchProducts();
  }

  void clearSearch() {
    _searchQuery = '';
    _products = [];
    skip = 0;
    hasMore = true;
    fetchProducts();
  }
}
