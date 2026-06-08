import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:test_1/models/category_model.dart';

import '../api_response/api_response.dart';
import '../models/product_model.dart';

class ProductService {
  final Dio dio = Dio()
    ..interceptors.add(PrettyDioLogger(requestBody: true, responseBody: true));

  // Future<ApiResponse<List<Product>>> getAllProducts() async {
  //   try {
  //     final response = await dio.get(
  //       "https://dummyjson.com/products",
  //       queryParameters: {"limit": 168, "skip": 0},
  //     );
  //     if (response.statusCode == 200) {
  //       final List products = response.data['products'];
  //       final data = products.map((e) => Product.fromJson(e)).toList();
  //       return ApiResponse(
  //         success: true,
  //         data: data,
  //         message: "Products loaded successfully",
  //       );
  //     }
  //     return ApiResponse(
  //       success: false,
  //       message: "Products loaded unsuccessful",
  //     );
  //   } catch (e) {
  //     e.toString();
  //     return ApiResponse(success: false, message: "Error");
  //   }
  // }

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
      debugPrint("Dio Error: ${e.type}");

      String message;

      switch (e.type) {
        case DioExceptionType.connectionError:
          message = "No internet connection";
          break;

        case DioExceptionType.connectionTimeout:
          message = "Connection timeout";
          break;

        case DioExceptionType.receiveTimeout:
          message = "Server response timeout";
          break;

        case DioExceptionType.sendTimeout:
          message = "Request timeout";
          break;

        case DioExceptionType.badResponse:
          message = e.response?.data['message'] ?? "Server returned an error";
          break;

        default:
          message = "Something went wrong";
      }

      return ApiResponse(success: false, message: message, error: e.toString());
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
    } catch (e) {
      return ApiResponse(success: false, message: "Search Failed");
    }
  }
}
