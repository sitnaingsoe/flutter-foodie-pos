import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:test_1/models/user_model.dart';
import '../api_response/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String errorMessage = "";

  static final Dio dio = Dio()
    ..interceptors.add(PrettyDioLogger(requestBody: true, responseBody: true));
  static Future<ApiResponse<UserModel>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        'https://dummyjson.com/auth/login',
        data: {"username": username, "password": password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final user = UserModel.fromJson(response.data);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isLoggedIn", true);
        await prefs.setString("token", data['accessToken'] ?? '');
        await prefs.setString("user", jsonEncode(data));
        return ApiResponse.success(data: user, message: "Login Success");
      } else {
        return ApiResponse.failure(message: "Login Failed");
      }
    } on DioException catch (e) {
      return ApiResponse.failure(
        message: "Login Failed",
        error: e.response?.data['message'],
      );
    }
  }
}
