import 'package:flutter/material.dart';

Widget buildEmptySearch() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.search_off, size: 80, color: Colors.grey),

        const SizedBox(height: 15),

        const Text(
          "No products found",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        const Text(
          "Try different keywords",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );
}
