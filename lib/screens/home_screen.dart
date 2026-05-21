import 'package:flutter/material.dart';
import 'package:test_1/models/product_model.dart';
import 'package:test_1/screens/product_detail_screen.dart';

import '../services/product_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService productService = ProductService();

  TextEditingController searchController = TextEditingController();

  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  List<String> categories = [];

  String selectedCategories = "all";

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    showProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // FETCH PRODUCTS
  Future<void> showProducts() async {
    isLoading = true;

    if (mounted) {
      setState(() {});
    }

    final response = await productService.getProducts();

    if (!mounted) return;

    if (response.success) {
      allProducts = response.data!;

      categories = allProducts.map((e) => e.category ?? '').toSet().toList();

      categories.insert(0, 'all');

      setState(() {
        filteredProducts = allProducts;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.error ?? response.message)),
      );
    }
  }

  // SEARCH + CATEGORY FILTER
  void applyFilter() {
    String query = searchController.text.toLowerCase();

    List<Product> temp = allProducts;

    // category filter
    if (selectedCategories != "all") {
      temp = temp.where((p) => p.category == selectedCategories).toList();
    }

    // search filter
    if (query.isNotEmpty) {
      temp = temp.where((p) => p.title.toLowerCase().contains(query)).toList();
    }

    if (!mounted) return;

    setState(() {
      filteredProducts = temp;
    });
  }

  // CATEGORY FILTER
  void filterByCategories(String category) {
    selectedCategories = category;

    applyFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOME"),
        automaticallyImplyLeading: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(10),

        child: Column(
          children: [
            // SEARCH BAR
            Padding(
              padding: const EdgeInsets.all(10),

              child: TextField(
                controller: searchController,
                onChanged: (value) => applyFilter(),

                decoration: InputDecoration(
                  hintText: "Search products...",
                  prefixIcon: const Icon(Icons.search),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            // CATEGORY BAR
            SizedBox(
              height: 60,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,

                itemBuilder: (context, index) {
                  final category = categories[index];

                  return GestureDetector(
                    onTap: () {
                      filterByCategories(category);
                    },

                    child: Container(
                      margin: const EdgeInsets.all(8),

                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),

                      decoration: BoxDecoration(
                        color: selectedCategories == category
                            ? Colors.blue
                            : Colors.grey.shade200,

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Center(
                        child: Text(
                          category.toUpperCase(),

                          style: TextStyle(
                            color: selectedCategories == category
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

            // PRODUCT GRID
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
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
                                BoxShadow(color: Colors.black12, blurRadius: 5),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                // PRODUCT IMAGE
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

                                // PRODUCT INFO
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        const SizedBox(height: 5),
                                        Text(
                                          product.title,

                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,

                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),

                                        const SizedBox(height: 5),

                                        Text(
                                          "⭐ ${product.rating}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),

                                        const SizedBox(height: 5),

                                        Text(
                                          "\$${product.price}",

                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),

                                        const Spacer(),

                                        SizedBox(
                                          width: double.infinity,

                                          child: ElevatedButton(
                                            onPressed: () {},

                                            child: const Text("Order"),
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
          ],
        ),
      ),
    );
  }
}
