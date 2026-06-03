import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/token_service.dart';
import '../services/api_service.dart';
import '../repositories/auth_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();

    final repository = AuthRepository(
      tokenService: TokenService(prefs),
      authService: AuthService(),
    );

    final isLoggedIn = await repository.isAuthenticated();

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, isLoggedIn ? "/home" : "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1C1C1C), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.jpg", height: 120),

            const SizedBox(height: 20),

            const Text(
              "My Shop",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Everything you need in one place",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
