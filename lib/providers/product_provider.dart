import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_1/api_response/api_response.dart';
import 'package:test_1/models/product_model.dart';
import 'package:test_1/services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  List<Product> _products = [];
  List<Product> _allProducts = [];

  bool _isFetching = false;
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

  List<Product> get allProducts => _allProducts;
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get isSearchEmpty => _searchQuery.isNotEmpty && filteredProducts.isEmpty;

  void bottomLoader() {
    if (isLoadingMore || !hasMore || _isLoading) return;
    isLoadingMore = true;
    _error = null;
    notifyListeners();
  }

  Future<void> fetchAllProducts() async {
    ApiResponse<List<Product>> response;
    response = await _service.getAllProducts();
    if (response.success == true && response.data != null) {
      _allProducts = response.data!;
    }
  }
  Future<void> fetchProducts() async {
    if (isLoadingMore || !hasMore || _isLoading || _error != null) return;

    if (_products.isEmpty) {
      _isLoading = true;
      _error = null;
      notifyListeners();
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

      if (response.success && response.data != null) {
        final newProducts = response.data!;

        if (newProducts.isEmpty) {
          hasMore = false;
        } else {
          _products.addAll(newProducts);
          skip += limit;
        }
        _error = null;
      } else {
        _error = response.error ?? response.message;
      }
    } catch (e) {
      _error = "လိုင်းမကောင်းပါ။ ကျေးဇူးပြု၍ ပြန်လည်ကြိုးစားပါ။";
    } finally {
      _isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  void retryFetchingNextPage() {
    _error = null;
    isLoadingMore = true;
    notifyListeners();

    Timer(const Duration(milliseconds: 300), () {
      refreshProducts();
    });
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
    _searchTimer = Timer(const Duration(seconds: 1), () {
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
    _error = null; // reset error

    notifyListeners();
    await fetchProducts();
  }

  Future<void> refreshProducts() async {
    _products.clear();
    skip = 0;
    hasMore = true;
    isLoadingMore = false;
    _error = null;
    _isLoading = true;
    notifyListeners();

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

      if (response.success && response.data != null) {
        final newProducts = response.data!;

        if (newProducts.isEmpty) {
          hasMore = false;
        } else {
          _products.addAll(newProducts);
          skip += limit;
        }
      } else {
        _error = response.error ?? response.message;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }

  
}
