import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/providers/cart_provider.dart';
import 'package:test_1/providers/category_provider.dart';
import 'package:test_1/providers/favorite_provider.dart';
import 'package:test_1/providers/product_provider.dart';
import 'package:test_1/widgets/product_cart.dart';

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  void initState() {
    super.initState();

    // SAFE INIT (fix async context warning)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().fetchCategories();
      context.read<ProductProvider>().fetchProducts();
    });

    // PAGINATION SCROLL
    scrollController.addListener(() {
      final provider = context.read<ProductProvider>();

      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !provider.isLoadingMore &&
          !provider.isLoading) {
        provider.fetchProducts();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final favoriteProvider = context.watch<FavoriteProvider>();
    final productProvider = context.watch<ProductProvider>();

    return Stack(
      children: [
        GridView.builder(
          controller: scrollController,

          padding: const EdgeInsets.all(10),

          // FIXED PAGINATION ITEM COUNT
          itemCount: productProvider.filteredProducts.length,

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 10,
            childAspectRatio: 0.66,
          ),

          itemBuilder: (context, index) {
            final product = productProvider.filteredProducts[index];

            return ProductCard(product: product);
          },
        ),
      ],
    );
  }
}
