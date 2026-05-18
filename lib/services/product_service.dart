import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/product_model.dart';

class ProductService {
  final Dio dio = Dio();
  ApiService() {
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      final response = await dio.get('https://dummyjson.com/products');
      if (response.statusCode == 200) {
        final data = response.data;
        List list = data['products'];
        return list.map((e) => Product.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint(e.toString());

      return [];
    }
  }
}
