import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
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
        data: {"username": username, "password": password, "expiresInMins": 30},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final user = UserModel.fromJson(response.data);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("accessToken", data['accessToken'] ?? '');
        await prefs.setString("refreshToken", data['refreshToken']);
        await prefs.setString("user", jsonEncode(data));
        final expiryTime = DateTime.now().add(const Duration(minutes: 5));
        await prefs.setString("expiryTime", expiryTime.toIso8601String());
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

  Future<bool> verifyAccessToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/auth/me'),
        headers: {"Authorization": "Bearer $token"},
      );
      return response.statusCode == 200;
    } catch (e) {
      e.toString();
      return false;
    }
  }

  Future<String?> refreshAccessToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse("https://dummyjson.com/auth/refresh"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refreshToken": refreshToken, "expiresInMins": 30}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["accessToken"];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
