import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1C1C1C); // dark elegant
  static const Color accentPink = Color(0xFFE8A0BF); // beauty feel
  static const Color gold = Color(0xFFC8A45D); // luxury feel

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: const Color(0xFFF7F7F7),

    primaryColor: primaryColor,

    appBarTheme: const AppBarTheme(
      backgroundColor: const Color(0xFF1C1C1C),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
    ),

    cardColor: Colors.white,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      hintStyle: const TextStyle(color: Colors.grey),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
  );
}
