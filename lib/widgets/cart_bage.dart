import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/providers/cart_provider.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.pushNamed(context, "/cart");
          },
        ),

        if (cartProvider.totalItems > 0)
          Positioned(
            top: 5,
            right: 5,
            child: CircleAvatar(
              radius: 9,
              backgroundColor: Colors.red,
              child: Text(
                "${cartProvider.totalItems}",
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
      ],
    );
  }
}
