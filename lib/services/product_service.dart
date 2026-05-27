import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:test_1/models/category_model.dart';

import '../api_response/api_response.dart';
import '../models/product_model.dart';

class ProductService {
  final Dio dio = Dio()
    ..interceptors.add(PrettyDioLogger(requestBody: true, responseBody: true));

  Future<ApiResponse<List<Product>>> getProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await dio.get(
        'https://dummyjson.com/products',
        queryParameters: {"limit": limit, "skip": skip},
      );

      if (response.statusCode == 200) {
        final List products = response.data['products'];

        final data = products.map((e) => Product.fromJson(e)).toList();

        return ApiResponse(
          success: true,
          data: data,
          message: "Products loaded successfully",
        );
      }

      return ApiResponse(success: false, message: "Failed to load products");
    } on DioException catch (e) {
      debugPrint(e.toString());

      return ApiResponse(
        success: false,
        message: "Request Failed",
        error: e.response?.data['message'] ?? "Network Error",
      );
    } catch (e) {
      debugPrint(e.toString());
      return ApiResponse(
        error: e.toString(),
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get(
        'https://dummyjson.com/products/categories',
      );
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((e) => CategoryModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<ApiResponse<List<Product>>> getProductsByCategory({
    required String category,
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await dio.get(
        "https://dummyjson.com/products/category/$category",
        queryParameters: {"limit": limit, "skip": skip},
      );
      if (response.statusCode == 200) {
        final List products = response.data['products'];
        final data = products.map((e) => Product.fromJson(e)).toList();
        return ApiResponse<List<Product>>(
          success: true,
          data: data,
          message: "Category products loaded",
        );
      }
      return ApiResponse<List<Product>>(
        success: false,
        message: "Error occurred",
      );
    } catch (e) {
      return ApiResponse<List<Product>>(
        success: false,
        message: "Error occurred",
        error: e.toString(),
      );
    }
  }
}
