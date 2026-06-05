import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/providers/favorite_provider.dart';
import 'package:test_1/providers/product_provider.dart';
import 'package:test_1/screens/product_detail_screen.dart';
import 'package:test_1/widgets/product_cart.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoirteIds = context.watch<FavoriteProvider>().favoriteIds;
    final products = context.watch<ProductProvider>().products;
    final favoriteProducts = products
        .where((product) => favoirteIds.contains(product.id))
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          return
          //
          //  child :  GridView.builder(
          //     padding: const EdgeInsets.all(16),
          //     itemCount: favoriteProducts.length,
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2,
          //       childAspectRatio: 0.65,
          //       crossAxisSpacing: 10,
          //       mainAxisSpacing: 10,
          //     ),
          //     itemBuilder: (context, index) {
          //       final product = favoriteProducts[index];
          //       return ProductCard(product: product);
          //     },
          //   );
          // );
          GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final product = favoriteProducts[index];
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
        },
      ),
    );
  }
}
