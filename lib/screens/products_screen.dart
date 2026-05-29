import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/providers/cart_provider.dart';
import 'package:test_1/providers/category_provider.dart';
import 'package:test_1/providers/product_provider.dart';

import '../services/product_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductService productService = ProductService();

  final ScrollController scrollController = ScrollController();

  final TextEditingController searchController = TextEditingController();

  String selectedCategories = "all";

  int cartCount = 0;
  int quantity = 1;

  int limit = 10;

  String currentCategory = "all";
  int categorySkip = 0;
  bool isCategoryMode = false;
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CategoryProvider>().fetchCategories();
      context.read<ProductProvider>().fetchProducts();
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        context.read<ProductProvider>().fetchProducts();
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

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // =========================
            // SEARCH BAR
            // =========================
            Padding(
              padding: const EdgeInsets.all(5),

              child: TextField(
                controller: searchController,

                onChanged: (value) {},

                decoration: InputDecoration(
                  hintText: "Search products...",

                  prefixIcon: const Icon(Icons.search),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            // =========================
            // CATEGORY LIST
            // =========================
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
                    onTap: () {},

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
                          category.slug.toUpperCase(),

                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // =========================
            // PRODUCT GRID
            // =========================
            Expanded(
              child: productProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            controller: scrollController,

                            padding: const EdgeInsets.all(10),

                            itemCount: productProvider.products.length,

                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 0.66,
                                ),

                            itemBuilder: (context, index) {
                              // SHOW BOTTOM LOADER
                              if (index == productProvider.products.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              final product = productProvider.products[index];

                              return GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,

                                  //   MaterialPageRoute(
                                  //     builder: (_) => ProductDetailScreen(
                                  //       product: product,
                                  //     ),
                                  //   ),
                                  // );
                                },

                                child: Container(
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
                                      // IMAGE
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

                                      // PRODUCT INFO
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),

                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,

                                            children: [
                                              // =========================
                                              // TITLE + FAVORITE ICON
                                              // =========================
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,

                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      product.title,

                                                      maxLines: 1,

                                                      overflow:
                                                          TextOverflow.ellipsis,

                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),

                                                  const SizedBox(width: 5),

                                                  Container(
                                                    height: 20,
                                                    width: 35,

                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade100,

                                                      shape: BoxShape.circle,
                                                    ),

                                                    child: IconButton(
                                                      padding: EdgeInsets.zero,

                                                      onPressed: () {},

                                                      icon: Icon(
                                                        Icons.favorite,

                                                        color: Colors.grey,

                                                        size: 25,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 8),

                                              // =========================
                                              // RATING
                                              // =========================
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.orange,
                                                    size: 18,
                                                  ),

                                                  const SizedBox(width: 4),

                                                  Text(
                                                    "${product.rating}",

                                                    style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 8),

                                              // =========================
                                              // PRICE
                                              // =========================
                                              Text(
                                                "\$${product.price}",

                                                style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),

                                              const Spacer(),

                                              // =========================
                                              // ADD TO CART BUTTON
                                              // =========================
                                              SizedBox(
                                                width: double.infinity,
                                                height: 42,

                                                child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    context
                                                        .read<CartProvider>()
                                                        .addToCart(product);
                                                  },

                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.black,

                                                    foregroundColor:
                                                        Colors.white,

                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                  ),

                                                  icon: Icon(
                                                    Icons
                                                        .shopping_cart_outlined,
                                                  ),

                                                  label: Text(
                                                    "Add to Cart",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // =========================
                        // BOTTOM LOADER
                        // // =========================
                        if (productProvider.isLoadingMore)
                          const Padding(
                            padding: EdgeInsets.all(15),
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
