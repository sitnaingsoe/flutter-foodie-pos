import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../models/product_model.dart';

class ProductService {
  static String errorMessage = "";

  final Dio dio = Dio()
    ..interceptors.add(PrettyDioLogger(requestBody: true, responseBody: true));

  Future<List<Product>> getProducts() async {
    try {
      // clear old error
      errorMessage = "";

      final response = await dio.get('https://dummyjson.com/products');

      if (response.statusCode == 200) {
        final data = response.data;

        List list = data['products'];

        return list.map((e) => Product.fromJson(e)).toList();
      }

      return [];
    } on DioException catch (e) {
      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? "Failed to load products";

        debugPrint(errorMessage);
      } else {
        errorMessage = "Network Error";

        debugPrint(errorMessage);
      }

      return [];
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(errorMessage);

      return [];
    }
  }
}
