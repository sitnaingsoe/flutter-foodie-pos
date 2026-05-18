import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
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
  TextEditingController SearchController = TextEditingController();
  List<Product> allProducts = [];
  List<String> categories = [];
  List<Product> filteredProducts = [];
  String selectedCategories = "all";
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    showProducts();
  }

  void applyFilter() {
    String query = SearchController.text.toLowerCase();
    List<Product> temp = allProducts;
    if (selectedCategories != "all") {
      temp = temp.where((p) => p.category == selectedCategories).toList();
    }
    if (query.isNotEmpty) {
      temp = temp.where((p) => p.title.toLowerCase().contains(query)).toList();
    }
    setState(() {
      filteredProducts = temp;
    });
  }

  Future<void> showProducts() async {
    isLoading = true;
    setState(() {});
    allProducts = await productService.getProducts();
    // category list
    categories = allProducts.map((e) => e.category ?? '').toSet().toList();
    categories.insert(0, 'all');
    setState(() {
      filteredProducts = allProducts;
    });
    isLoading = false;
  }

  void filterByCategories(String category) {
    setState(() {
      selectedCategories = category;
      if (category == "all") {
        filteredProducts = allProducts;
      } else {
        filteredProducts = allProducts
            .where((p) => p.category == category)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("HOME"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            //searchBar
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: SearchController,
                onChanged: (value) => applyFilter(),
                decoration: InputDecoration(
                  hintText: "Search products ...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            // CategoryBar
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
                            : Colors.grey.shade100,
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
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                          builder: (_) => ProductDetailScreen(product: product),
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
                          // 🖼 PRODUCT IMAGE
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
                            ),
                          ),

                          // 📄 PRODUCT INFO
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    product.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,

                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    "⭐ ${product.rating}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    "\$${product.price}",

                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const Spacer(),

                                  // 🛒 ADD TO CART BUTTON
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
