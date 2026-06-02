import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/providers/cart_provider.dart';
import 'package:test_1/providers/favorite_provider.dart';
import 'package:test_1/providers/product_provider.dart';
import 'package:test_1/widgets/add_to_cart_button.dart';
import 'package:test_1/widgets/favorite_button.dart';

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
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

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 5),
                ],
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
                      errorBuilder: (context, error, stackTrace) {
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
                        const SizedBox(height: 3),

                        Row(
                          children: [
                            // FAVORITE BUTTON
                            FavoriteButton(
                              isFavorite: favoriteProvider.isFavorite(
                                product.id,
                              ),
                              onTap: () {
                                final isFav = favoriteProvider.isFavorite(
                                  product.id,
                                );
                                if (isFav) {
                                  favoriteProvider.removeFromFavorites(product);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        "${product.title} removed Form Your Favorites",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  favoriteProvider.addToFavorite(product);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "${product.title} added to favorites ",
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),

                            // ADD TO CART BUTTON (takes remaining space)
                            Expanded(
                              child: AddToCartButton(
                                isAdded: cartProvider.isInCart(product.id),
                                onPressed: () {
                                  final added = cartProvider.addToCart(product);
                                  ScaffoldMessenger.of(
                                    context,
                                  ).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: added
                                          ? Colors.green
                                          : const Color.fromARGB(
                                              255,
                                              60,
                                              60,
                                              59,
                                            ),
                                      behavior: SnackBarBehavior.floating,

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      content: Text(
                                        added
                                            ? "${product.title} added to cart "
                                            : "${product.title} is already in cart",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
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
          },
        ),
      ],
    );
  }
}
