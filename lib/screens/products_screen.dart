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
    searchController.clear();
    final category = context.read<CategoryProvider>();
    if (category.categories.isEmpty) {
      category.fetchCategories();
    }

    final provider = context.read<ProductProvider>();
    if (provider.products.isEmpty) {
      provider.fetchProducts();
    }

    scrollController.addListener(() {
      if (!scrollController.hasClients) return;

      final provider = context.read<ProductProvider>();
      final position = scrollController.position;

      if (position.pixels >= position.maxScrollExtent - 400 &&
          !provider.isLoadingMore &&
          !provider.isLoading &&
          provider.hasMore) {
        provider.fetchProducts();
        provider.bottomLoader();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final categoryProvider = context.watch<CategoryProvider>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("HOME"),
          automaticallyImplyLeading: false,
          actions: [CartBadge(searchController: searchController)],
        ),
        body: categoryProvider.categories.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ProductSearchBar(controller: searchController),
                    const SizedBox(height: 10),

                    const CategoryList(),

                    const SizedBox(height: 10),

                    Expanded(
                      child: productProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : productProvider.filteredProducts.isEmpty
                          ? buildEmptySearch()
                          : RefreshIndicator(
                              onRefresh: () async {
                                await context
                                    .read<ProductProvider>()
                                    .refreshProducts();
                              },
                              child: ProductGrid(controller: scrollController),
                            ),
                    ),

                    if (productProvider.isLoadingMore)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
