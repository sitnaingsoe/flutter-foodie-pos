import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test_1/Theme/app_theme.dart';
import 'package:test_1/providers/cart_provider.dart';
import 'package:test_1/providers/category_provider.dart';
import 'package:test_1/providers/favorite_provider.dart';
import 'package:test_1/providers/product_provider.dart';

import 'package:test_1/screens/login_screen.dart';
import 'package:test_1/screens/home_screen.dart';
import 'package:test_1/screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
         ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
