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
import 'package:test_1/widgets/product_grid.dart';
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
    searchController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().fetchCategories();

      context.read<ProductProvider>().refreshProducts();
    });

  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    final provider = context.read<ProductProvider>();

    if (provider.isLoading ||
        provider.isLoadingMore ||
        !provider.hasMore ||
        provider.error != null) {
      return false;
    }

    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 200) {
      provider.fetchProducts();
      provider.bottomLoader();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final categoryProvider = context.watch<CategoryProvider>();

    final bool isInitialLoadError = productProvider.error != null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Shop"),
          automaticallyImplyLeading: false,
          actions: [CartBadge(searchController: searchController)],
        ),
        // products_screen.dart ထဲက body နေရာတွင် အစားထိုးရန်
        body: isInitialLoadError
            ? ErrorScreen(
                onRetry: () async {
                  await context.read<ProductProvider>().refreshProducts();
                  await context.read<CategoryProvider>().fetchCategories();
                },
              )
            : categoryProvider.categories.isEmpty &&
                  productProvider.products.isEmpty
            ? const ProductSkeletonGrid()
            : Padding(
                padding: const EdgeInsets.all(10),
                child: CustomScrollView(
                  controller:
                      scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          ProductSearchBar(controller: searchController),
                          const SizedBox(height: 10),
                          const CategoryList(),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),

                    
                    if (productProvider.isLoading)
                      const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (productProvider.filteredProducts.isEmpty)
                      SliverFillRemaining(child: NotFound())
                    else
                     
                      SliverPadding(
                        padding: const EdgeInsets.all(0),
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
                                      builder: (_) =>
                                          ProductDetailScreen(product: product),
                                    ),
                                  );
                                },
                                child: ProductCard(product: product),
                              );
                            },
                            childCount: productProvider.filteredProducts.length,
                          ),
                        ),
                      ),

                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          if (productProvider.isLoadingMore)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: CircularProgressIndicator(),
                            )
                          else if (productProvider.error != null )
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Try Again",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  TextButton(
                                    onPressed: () => context
                                        .read<ProductProvider>()
                                        .retryFetchingNextPage(),
                                    child: const Text("Retry"),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
