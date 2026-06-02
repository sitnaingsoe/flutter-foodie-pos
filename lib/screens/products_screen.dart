import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/providers/cart_provider.dart';
import 'package:test_1/providers/category_provider.dart';
import 'package:test_1/providers/favorite_provider.dart';
import 'package:test_1/providers/product_provider.dart';
import 'package:test_1/widgets/add_to_cart_button.dart';
import 'package:test_1/widgets/favorite_button.dart';
import 'package:test_1/widgets/not_found.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

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
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final cartProvider = context.watch<CartProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final favoriteProvider = context.watch<FavoriteProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOME"),
        automaticallyImplyLeading: false,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart),
              ),
              if (cartProvider.totalItems > 0)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "${cartProvider.totalItems}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      // SAFE LOADING STATE
      body: categoryProvider.categories.isEmpty
          ? Center(child: const CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // SEARCH
                  TextField(
                    controller: searchController,
                    onChanged: (value) {
                      context.read<ProductProvider>().searchProducts(value);
                    },
                    decoration: InputDecoration(
                      hintText: "Search products...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // CATEGORY LIST
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryProvider.categories.length,
                      itemBuilder: (context, index) {
                        final category = categoryProvider.categories[index];

                        final isSelected =
                            categoryProvider.selectedCategory == category.slug;

                        return GestureDetector(
                          onTap: () {
                            context.read<ProductProvider>().setCategory(
                              category.slug,
                            );
                            context.read<CategoryProvider>().selectCategory(
                              category.slug,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF1C1C1C)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF1C1C1C)
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                category.name,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // PRODUCT GRID
                  Expanded(
                    child: productProvider.isLoading
                        ? Center(child: const CircularProgressIndicator())
                        : productProvider.filteredProducts.isEmpty
                        ? buildEmptySearch()
                        : Stack(
                            children: [
                              GridView.builder(
                                controller: scrollController,

                                padding: const EdgeInsets.all(10),

                                // FIXED PAGINATION ITEM COUNT
                                itemCount:
                                    productProvider.filteredProducts.length,

                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 0.66,
                                    ),

                                itemBuilder: (context, index) {
                                  final product =
                                      productProvider.filteredProducts[index];

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            errorBuilder:
                                                (context, error, stackTrace) {
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
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
                                                    isFavorite: favoriteProvider
                                                        .isFavorite(product.id),
                                                    onTap: () {
                                                      final isFav =
                                                          favoriteProvider
                                                              .isFavorite(
                                                                product.id,
                                                              );
                                                      if (isFav) {
                                                        favoriteProvider
                                                            .removeFromFavorites(
                                                              product,
                                                            );
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            backgroundColor:
                                                                Colors.red,
                                                            content: Text(
                                                              "${product.title} removed Form Your Favorites",
                                                              style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        favoriteProvider
                                                            .addToFavorite(
                                                              product,
                                                            );
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
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
                                                      isAdded: cartProvider
                                                          .isInCart(product.id),
                                                      onPressed: () {
                                                        final added =
                                                            cartProvider
                                                                .addToCart(
                                                                  product,
                                                                );
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).hideCurrentSnackBar();
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            backgroundColor:
                                                                added
                                                                ? Colors.green
                                                                : const Color.fromARGB(
                                                                    255,
                                                                    60,
                                                                    60,
                                                                    59,
                                                                  ),
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,

                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12,
                                                                  ),
                                                            ),
                                                            content: Text(
                                                              added
                                                                  ? "${product.title} added to cart "
                                                                  : "${product.title} is already in cart",
                                                              style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                              if (productProvider.isLoadingMore)
                                const Positioned(
                                  bottom: 20,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                            ],
                          ),
                  ),

                  // Bottom Loader
                ],
              ),
            ),
    );
  }
}
