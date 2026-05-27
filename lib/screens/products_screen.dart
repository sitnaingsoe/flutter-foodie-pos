import 'package:flutter/material.dart';
import 'package:test_1/models/category_model.dart';
import 'package:test_1/models/product_model.dart';
import 'package:test_1/screens/product_detail_screen.dart';

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

  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  List<CategoryModel> categories = [];

  List<Product> favoriteProducts = [];

  List<Product> cartProducts = [];

  String selectedCategories = "all";

  int cartCount = 0;
  int quantity = 1;

  int limit = 10;
  int skip = 0;

  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;

  String currentCategory = "all";
  int categorySkip = 0;
  bool isCategoryMode = false;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchProducts();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMore();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // =========================
  // FETCH CATEGORIES
  // =========================
  Future<void> fetchCategories() async {
    final data = await productService.getCategories();

    categories = data;

    categories.insert(0, CategoryModel(slug: "all", name: "All"));

    if (mounted) {
      setState(() {});
    }
  }

  // =========================
  // FETCH PRODUCTS
  // =========================
  Future<void> fetchProducts() async {
    isLoading = true;

    if (mounted) {
      setState(() {});
    }

    final response = await productService.getProducts(limit: limit, skip: skip);

    if (!mounted) return;

    if (response.success) {
      final products = response.data!;

      allProducts = products;
      filteredProducts = products;

      if (products.length < limit) {
        hasMore = false;
      } else {
        hasMore = true;
      }

      isLoading = false;

      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.error ?? response.message)),
      );

      isLoading = false;

      setState(() {});
    }
  }

  // =========================
  // LOAD MORE
  // =========================
  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;

    setState(() {});

    try {
      if (isCategoryMode) {
        categorySkip += limit;

        final response = await productService.getProductsByCategory(
          category: currentCategory,
          limit: limit,
          skip: categorySkip,
        );

        if (response.success) {
          final newProducts = response.data!;

          if (newProducts.isEmpty) {
            hasMore = false;
          } else {
            allProducts.addAll(newProducts);
            filteredProducts.addAll(newProducts);
          }
        }
      } else {
        skip += limit;

        final response = await productService.getProducts(
          limit: limit,
          skip: skip,
        );

        if (response.success) {
          final newProducts = response.data!;

          if (newProducts.isEmpty) {
            hasMore = false;
          } else {
            allProducts.addAll(newProducts);
            filteredProducts.addAll(newProducts);
          }
        }
      }
    } catch (e) {
      debugPrint("LoadMore Error : $e");
    }

    isLoadingMore = false;

    setState(() {});
  }

  // check Favourite

  bool isFavorite(Product product) {
    return favoriteProducts.contains(product);
  }

  // =========================
  // APPLY FILTER
  // =========================
  void applyFilter() {
    String query = searchController.text.toLowerCase();

    List<Product> temp = allProducts;

    // CATEGORY FILTER
    if (selectedCategories != "all") {
      temp = temp.where((p) => p.category == selectedCategories).toList();
    }

    // SEARCH FILTER
    if (query.isNotEmpty) {
      temp = temp.where((p) => p.title.toLowerCase().contains(query)).toList();
    }

    if (!mounted) return;

    setState(() {
      filteredProducts = temp;
    });
  }

  // =========================
  // FETCH CATEGORY PRODUCTS
  // =========================
  Future<void> fetchByCategories(String category) async {
    isLoading = true;

    setState(() {});

    currentCategory = category;
    isCategoryMode = category != "all";
    categorySkip = 0;

    final response = await productService.getProductsByCategory(
      category: category,
      limit: limit,
      skip: categorySkip,
    );

    if (response.success) {
      allProducts = response.data!;
      filteredProducts = response.data!;

      hasMore = true;
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));
    }

    isLoading = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOME"),
        automaticallyImplyLeading: false,

        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  
                },
                icon: const Icon(Icons.shopping_cart),
              ),

              if (cartCount > 0)
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
                      "$cartCount",

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
              padding: const EdgeInsets.all(10),

              child: TextField(
                controller: searchController,

                onChanged: (value) {
                  applyFilter();
                },

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

                itemCount: categories.length,

                itemBuilder: (context, index) {
                  final category = categories[index];

                  return GestureDetector(
                    onTap: () {
                      selectedCategories = category.slug;

                      setState(() {});

                      if (category.slug == "all") {
                        fetchProducts();
                      } else {
                        fetchByCategories(category.slug);
                      }
                    },

                    child: Container(
                      margin: const EdgeInsets.all(8),

                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),

                      decoration: BoxDecoration(
                        color: selectedCategories == category.slug
                            ? const Color(0xFF1C1C1C)
                            : Colors.grey.shade100,

                        borderRadius: BorderRadius.circular(20),

                        border: Border.all(
                          color: selectedCategories == category.slug
                              ? const Color(0xFF1C1C1C)
                              : Colors.grey.shade300,
                        ),
                      ),

                      child: Center(
                        child: Text(
                          category.name.toUpperCase(),

                          style: TextStyle(
                            color: selectedCategories == category.slug
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

            // =========================
            // PRODUCT GRID
            // =========================
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            controller: scrollController,

                            padding: const EdgeInsets.all(10),

                            itemCount: filteredProducts.length,

                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 0.66,
                                ),

                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ProductDetailScreen(product: product),
                                    ),
                                  );
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
                                          product.images?.first ?? '',

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
                                                          favoriteProducts
                                                              .contains(product)
                                                          ? Colors.red.shade50
                                                          : Colors
                                                                .grey
                                                                .shade100,

                                                      shape: BoxShape.circle,
                                                    ),

                                                    child: IconButton(
                                                      padding: EdgeInsets.zero,

                                                      onPressed: () {
                                                        setState(() {
                                                          if (favoriteProducts
                                                              .contains(
                                                                product,
                                                              )) {
                                                            favoriteProducts
                                                                .remove(
                                                                  product,
                                                                );

                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  "${product.title} removed from favorites",
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            favoriteProducts
                                                                .add(product);

                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  "${product.title} added to Your favorites ❤️",
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        });
                                                      },

                                                      icon: Icon(
                                                        favoriteProducts
                                                                .contains(
                                                                  product,
                                                                )
                                                            ? Icons.favorite
                                                            : Icons
                                                                  .favorite_border,

                                                        color:
                                                            favoriteProducts
                                                                .contains(
                                                                  product,
                                                                )
                                                            ? Colors.black
                                                            : Colors.grey,

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
                                                    if (!cartProducts.contains(
                                                      product,
                                                    )) {
                                                      setState(() {
                                                        cartProducts.add(
                                                          product,
                                                        );
                                                        cartCount =
                                                            cartProducts.length;
                                                      });

                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            "${product.title} added to cart 🛒",
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            "${product.title} already in cart",
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },

                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        cartProducts.contains(
                                                          product,
                                                        )
                                                        ? Colors.green
                                                        : Colors.black,

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
                                                    cartProducts.contains(
                                                          product,
                                                        )
                                                        ? Icons.check
                                                        : Icons
                                                              .shopping_cart_outlined,
                                                  ),

                                                  label: Text(
                                                    cartProducts.contains(
                                                          product,
                                                        )
                                                        ? "Added"
                                                        : "Add Cart",
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
                        // =========================
                        if (isLoadingMore)
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
