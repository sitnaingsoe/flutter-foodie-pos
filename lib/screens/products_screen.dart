import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/providers/category_provider.dart';
import 'package:test_1/providers/product_provider.dart';
import 'package:test_1/screens/product_detail_screen.dart';
import 'package:test_1/widgets/cart_bage.dart';
import 'package:test_1/widgets/category_list.dart';
import 'package:test_1/widgets/error.dart';
import 'package:test_1/widgets/not_found.dart';
import 'package:test_1/widgets/product_cart.dart';
import 'package:test_1/widgets/product_skeleton_grid.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<CategoryProvider>().fetchCategories();
      await context.read<ProductProvider>().initialFetchProduct();
    });

    searchController.addListener(() {
      setState(() {}); // Refresh clear button visibility
    });
  }

  Future<void> _onRefresh() async {
    await Future.wait([
       context.read<CategoryProvider>().fetchCategories(),
      context.read<ProductProvider>().refreshProducts(),
     
    ]);
  }

  bool _onScrollNotification(ScrollNotification notification) {
    final provider = context.read<ProductProvider>();

    if (provider.isLoading || provider.isLoadingMore || !provider.hasMore ) {
      return false;
    }

    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 50 && provider.error == null) {
      provider.fetchProducts();
      provider.bottomLoader();
    }

    return false;
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

    final bool isInitialLoadError =
        productProvider.error != null &&
        productProvider.filteredProducts.isEmpty && categoryProvider.categories.isEmpty;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Shop"),
          automaticallyImplyLeading: false,
          actions: [CartBadge(searchController: searchController)],
        ),

        body: isInitialLoadError
            ? ErrorScreen(onRetry: _onRefresh)
            : RefreshIndicator(
                onRefresh:_onRefresh,
                child: NotificationListener<ScrollNotification>(
                  onNotification: _onScrollNotification,
                  child: CustomScrollView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              ProductSearchBar(controller: searchController),
                              const SizedBox(height: 10),
                              const CategoryList(),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),

                      if (productProvider.isLoading)
                        const SliverFillRemaining(child: ProductSkeletonGrid())
                      else if (productProvider.filteredProducts.isEmpty)
                        const SliverFillRemaining(child: NotFound())
                      else
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 0.66,
                                ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final product =
                                    productProvider.filteredProducts[index];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailScreen(
                                          product: product,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ProductCard(product: product),
                                );
                              },
                              childCount:
                                  productProvider.filteredProducts.length,
                            ),
                          ),
                        ),

                      if (productProvider.isLoadingMore)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),

                      if (productProvider.error != null &&
                          productProvider.products.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 30),
                            child: Center(
                              child: Column(
                                children: [
                                  const Text(
                                    "Failed to load more products",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      
                                      context
                                          .read<ProductProvider>()
                                          .fetchProducts();
                                    },
                                    child: const Text("Try Again"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
