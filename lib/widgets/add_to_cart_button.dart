import 'package:flutter/material.dart';

class AddToCartButton extends StatelessWidget {
  final bool isAdded;
  final VoidCallback onPressed;

  const AddToCartButton({
    super.key,
    required this.isAdded,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 45,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        label: Text(
          isAdded ? "Added " : "Add to Cart",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          elevation: isAdded ? 0 : 3,
          backgroundColor: isAdded ? Colors.green : Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
