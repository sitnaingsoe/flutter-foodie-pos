// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("accessToken");
    final refreshToken = prefs.getString("refreshToken");

    await Future.delayed(const Duration(seconds: 2));
    if (accessToken == null || refreshToken == null) {
      goLogin();
      return;
    } else {
      final isvalid = await verifyAccessToken(accessToken);
      if (isvalid) {
        goHome();
      } else {
        final refreshed = await verifyRefreshToken(refreshToken);
        if (refreshed) {
          goHome();
        } else {
          goLogin();
        }
      }
    }
  }

  Future<bool> verifyAccessToken(String accessToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final expiryString = prefs.getString("expiryTime");
      if (expiryString == null) {
        return false;
      }
      final expiryTime = DateTime.parse(expiryString);

      if (DateTime.now().isAfter(expiryTime)) {
        return false;
      }
      final url = 'https://dummyjson.com/auth/me';
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $accessToken"},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyRefreshToken(String refreshToken) async {
    try {
      final respone = await http.post(
        Uri.parse('https://dummyjson.com/auth/refresh'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refreshToken": refreshToken, "expiresInMins": 30}),
      );
      if (respone.statusCode == 200) {
        final data = jsonDecode(respone.body);
        final newAccessToken = data['accessToken'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("accessToken", newAccessToken);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void goLogin() {
    Navigator.pushReplacementNamed(context, "/login");
  }

  void goHome() {
    Navigator.pushReplacementNamed(context, "/home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
