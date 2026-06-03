import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/providers/category_provider.dart';
import 'package:test_1/providers/product_provider.dart';
import 'package:test_1/widgets/cart_bage.dart';
import 'package:test_1/widgets/category_list.dart';
import 'package:test_1/widgets/not_found.dart';
import 'package:test_1/widgets/product_grid.dart';
import 'package:test_1/widgets/search_bar.dart';

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
    final categoryProvider = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("HOME"),
        automaticallyImplyLeading: false,
        actions: [CartBadge()],
      ),

      // SAFE LOADING STATE
      body: categoryProvider.categories.isEmpty
          ? Center(child: const CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // SEARCH
                  const ProductSearchBar(),
                  const SizedBox(height: 10),
                  // CATEGORY LIST
                  const CategoryList(),
                  const SizedBox(height: 10),
                  // PRODUCT GRID
                  Expanded(
                    child: productProvider.isLoading
                        ? Center(child: const CircularProgressIndicator())
                        : productProvider.filteredProducts.isEmpty
                        ? buildEmptySearch()
                        : ProductGrid(),
                  ),
                  // Bottom Loader
                  if (productProvider.isLoadingMore)
                    const Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
    );
  }
}
