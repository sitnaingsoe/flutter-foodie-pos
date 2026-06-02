import 'package:flutter/material.dart';
Widget buildGridItem(
  IconData icon,
  String title,
  Color color,
  VoidCallback onTap,
) {
  return Container(
    margin: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(10),
          blurRadius: 4,
          offset: const Offset(0, 7),
        ),
      ],
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    ),
  );
}