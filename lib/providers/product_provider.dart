import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_1/api_response/api_response.dart';
import 'package:test_1/models/product_model.dart';
import 'package:test_1/services/product_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  final List<Product> _products = [];
  List<Product> _allProducts = [];
  StreamSubscription<List<ConnectivityResult>>? _connectionSubscription;

  bool _isLoading = true;
  String? _error;

  String _searchQuery = '';
  String _selectedCategory = 'all';

  bool _isSearching = false;
  Timer? _searchTimer;

  int limit = 6;
  int skip = 0;
  bool hasMore = true;
  bool isLoadingMore = false;

  bool _isConnected = true;

  bool get isConnected => _isConnected;

  List<Product> get allProducts => _allProducts;
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get isSearchEmpty => _searchQuery.isNotEmpty && filteredProducts.isEmpty;

  void bottomLoader() {
    if (!_isConnected || isLoading || isLoadingMore) return;

    isLoadingMore = true;
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
    if (!_isConnected) {
      _error = "No Internet Connection";
      notifyListeners();
      return;
    }
    if (isLoadingMore || _isLoading || !hasMore) {
      return;
    }

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
        _error = "No Internet Connection";
      }
    } catch (e) {
      _error = "No Internet Connection";
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

  Future<void> initialFetchProduct() async {
    _isLoading = true;

    final response = await _service.getProducts(limit: limit, skip: skip);
    if (response.success && response.data != null) {
      final initialProduct = response.data!;

      if (initialProduct.isEmpty) {
        hasMore = false;
      } else {
        _products.addAll(initialProduct);
        skip += limit;
      }
      _error = null;
    } else {
      _error = 'No Internet Connection';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshProducts() async {
    if (!_isConnected) {
      _error = "No Internet Connection";
      notifyListeners();
      return;
    }
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

  ProductProvider() {
    _listenNetwork();
  }

  void _listenNetwork() {
    _connectionSubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      _isConnected = !results.contains(ConnectivityResult.none);

      if (_isConnected) {
        _error = null;
        if (_products.isEmpty) {
          refreshProducts();
        }
        notifyListeners();
      } else {
        _error = "No Internet Connection";
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }
}
