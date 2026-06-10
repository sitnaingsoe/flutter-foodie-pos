import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:test_1/models/category_model.dart';
import '../api_response/api_response.dart';
import '../models/product_model.dart';

class ProductService {
  
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(
        seconds: 5,
      ),
      receiveTimeout: const Duration(
        seconds: 5,
      ),
      sendTimeout: const Duration(seconds: 5),
    ),
  );

  
  String _handleDioError(DioException e) {
    debugPrint("Dio Error Type: ${e.type}");
    switch (e.type) {
      case DioExceptionType.connectionError:
        return "no internet connection";
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return "request time out";
      case DioExceptionType.badResponse:
        return e.response?.data['message'] ?? "sever error";
      default:
        return "something want wrong";
    }
  }

  Future<ApiResponse<List<Product>>> getAllProducts() async {
    try {
      final response = await dio.get(
        "https://dummyjson.com/products",
        queryParameters: {"limit": 168, "skip": 0},
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
      return ApiResponse(
        success: false,
        message: "Products loaded unsuccessful",
      );
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: _handleDioError(e),
        error: e.toString(),
      );
    } catch (e) {
      return ApiResponse(success: false, message: "Error", error: e.toString());
    }
  }

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

        return ApiResponse(
          success: true,
          data: products.map((e) => Product.fromJson(e)).toList(),
          message: "Products loaded successfully",
        );
      }

      return ApiResponse(success: false, message: "Failed to load products");
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: _handleDioError(e),
        error: e.toString(),
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: "Unexpected error occurred",
        error: e.toString(),
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
    } on DioException catch (e) {
      debugPrint("Categories Dio Error: ${_handleDioError(e)}");
      return [];
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
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: _handleDioError(e),
        error: e.toString(),
      );
    } catch (e) {
      return ApiResponse<List<Product>>(
        success: false,
        message: "Error occurred",
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<List<Product>>> searchProducts({
    required String query,
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await dio.get(
        'https://dummyjson.com/products/search',
        queryParameters: {"q": query, "limit": limit, "skip": skip},
      );
      if (response.statusCode == 200) {
        final List products = response.data['products'];
        final data = products.map((e) => Product.fromJson(e)).toList();
        return ApiResponse<List<Product>>(
          success: true,
          data: data,
          message: "Search successful",
        );
      }
      return ApiResponse(success: false, message: "Failed to search");
    } on DioException catch (e) {
      return ApiResponse(
        success: false,
        message: _handleDioError(e),
        error: e.toString(),
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: "Search Failed",
        error: e.toString(),
      );
    }
  }
}
