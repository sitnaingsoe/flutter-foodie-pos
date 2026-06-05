import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/product_model.dart';
import 'package:test_1/providers/cart_provider.dart';
import 'package:test_1/providers/favorite_provider.dart';
import 'package:test_1/widgets/add_to_cart_button.dart';
import 'package:test_1/widgets/favorite_button.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final favoriteProvider = context.watch<FavoriteProvider>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              product.thumbnail ?? '',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                return Image.asset(
                  'assets/images/default.png',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 5),

                Text("⭐ ${product.rating}"),

                const SizedBox(height: 5),

                Text(
                  "\$${product.price}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    FavoriteButton(
                      isFavorite: favoriteProvider.isFavorite(product.id),
                      onTap: () {
                        final isFavorite = favoriteProvider.isFavorite(
                          product.id,
                        );
                        favoriteProvider.toggleFavorite(product.id);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: isFavorite
                                ? const Color.fromARGB(255, 184, 10, 10)
                                : const Color.fromARGB(255, 79, 69, 69),
                            content: Text(
                              isFavorite
                                  ? "${product.title} removed from favorites"
                                  : "${product.title} add to favorites",
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),

                    Expanded(
                      child: AddToCartButton(
                        isAdded: cartProvider.isInCart(product.id),
                        onPressed: () {
                          final isInCart = cartProvider.isInCart(product.id);

                          if (isInCart) {
                            cartProvider.removeItem(product.id);
                          } else {
                            cartProvider.addToCart(product.id);
                          }

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: isInCart
                                  ? Colors.black
                                  : Colors.green,
                              content: Text(
                                isInCart
                                    ? "${product.title} Added in cart"
                                    : "${product.title} removed from cart"
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
