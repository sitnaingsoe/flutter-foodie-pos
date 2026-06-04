import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/providers/cart_provider.dart';
import 'package:test_1/providers/product_provider.dart';

class CartBadge extends StatelessWidget {
  final TextEditingController searchController;
  const CartBadge({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            searchController.clear();
            context.read<ProductProvider>().clearSearch();
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
