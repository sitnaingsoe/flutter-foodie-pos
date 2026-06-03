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
                        if (favoriteProvider.isFavorite(product.id)) {
                          favoriteProvider.removeFromFavorites(product);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                "${product.title} removed from favorites",
                              ),
                            ),
                          );
                        } else {
                          favoriteProvider.addToFavorite(product);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                "${product.title} added to favorites ❤️",
                              ),
                            ),
                          );
                        }
                      },
                    ),

                    Expanded(
                      child: AddToCartButton(
                        isAdded: cartProvider.isInCart(product.id),
                        onPressed: () {
                          final added = cartProvider.addToCart(product);

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: added
                                  ? Colors.green
                                  : const Color.fromARGB(255, 13, 11, 11),
                              content: Text(
                                added
                                    ? "${product.title} added to cart"
                                    : "${product.title} already in cart",
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
