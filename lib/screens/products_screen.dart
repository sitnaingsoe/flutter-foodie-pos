import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/providers/category_provider.dart';
import 'package:test_1/providers/product_provider.dart';
import 'package:test_1/widgets/cart_bage.dart';
import 'package:test_1/widgets/category_list.dart';
import 'package:test_1/widgets/not_found.dart';
import 'package:test_1/widgets/product_cart.dart';
import 'package:test_1/screens/product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late final ScrollController scrollController;
  final TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(_onScroll);
    searchController.clear();

    final category = context.read<CategoryProvider>();
    final productProvider = context.read<ProductProvider>();

    if (category.categories.isEmpty) {
      category.fetchCategories();
    }

    if (productProvider.products.isEmpty) {
      productProvider.fetchProducts();
    }
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    final provider = context.read<ProductProvider>();

    if (scrollController.position.pixels >
            scrollController.position.maxScrollExtent - 300 &&
        !provider.isLoadingMore &&
        provider.hasMore) {
      provider.fetchProducts();
    }
  }

  Future<void> _refresh() async {
    await Future.wait([
      context.read<ProductProvider>().refreshProducts(),
      context.read<CategoryProvider>().fetchCategories(),
    ]);
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Amazon Store"),
        automaticallyImplyLeading: false,
        actions: [CartBadge(searchController: searchController)],
      ),

      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),

          slivers: [
            // 🔍 SEARCH + CATEGORY (Sticky style)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search products...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        context.read<ProductProvider>().searchProducts(value);
                      },
                    ),

                    const SizedBox(height: 10),
                    const CategoryList(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // 📦 EMPTY STATE
            if (productProvider.filteredProducts.isEmpty &&
                !productProvider.isLoading)
              const SliverToBoxAdapter(child: NotFound()),

            // 🛍 PRODUCT GRID (Amazon style)
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final product = productProvider.filteredProducts[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: ProductCard(product: product),
                  );
                }, childCount: productProvider.filteredProducts.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
              ),
            ),

            // 🔄 LOADING MORE
            if (productProvider.isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
