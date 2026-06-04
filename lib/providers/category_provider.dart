import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/product_service.dart';

class CategoryProvider extends ChangeNotifier {
  final ProductService _service = ProductService();
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;
  bool isLoading = false;
  String selectedCategory = "all";

  Future<void> fetchCategories() async {
    isLoading = true;
    try {
      final data = await _service.getCategories();
      _categories = data;
      _categories.insert(0, CategoryModel(slug: "all", name: "All"));
    } catch (e) {
      debugPrint("Category Error: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  void selectCategory(String slug) {
    selectedCategory = slug;
    notifyListeners();
  }
}

