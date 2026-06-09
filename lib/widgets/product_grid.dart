import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/providers/product_provider.dart';
import 'package:test_1/screens/product_detail_screen.dart';
import 'package:test_1/widgets/product_cart.dart';

class ProductGrid extends StatelessWidget {
  final ScrollController controller;

  const ProductGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return GridView.builder(
      controller: controller,
      padding: const EdgeInsets.all(10),
      itemCount: productProvider.filteredProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 10,
        childAspectRatio: 0.66,
      ),
      itemBuilder: (context, index) {
        final product = productProvider.filteredProducts[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(product: product),
              ),
            );
          },
          child: ProductCard(product: product),
        );
      },
    );
  }
}