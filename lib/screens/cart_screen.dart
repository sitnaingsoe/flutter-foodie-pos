import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/cartitem_model.dart';
import 'package:test_1/providers/cart_provider.dart';
import 'package:test_1/providers/product_provider.dart';
import 'package:test_1/widgets/cart_summary.dart';
import 'package:test_1/widgets/cart_item_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<ProductProvider>();
    provider.fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final productProvider = context.watch<ProductProvider>();

    final cartItems = cartProvider.cartItems;
    // Map<int, int> → productId : quantity

    final products = productProvider.allProducts;

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: cartItems.entries.map((entry) {
                final productId = entry.key;
                final quantity = entry.value;

                final foundProducts = products.where((p) => p.id == productId);

                if (foundProducts.isEmpty) {
                  return const SizedBox.shrink();
                }

                final product = foundProducts.first;

                final item = CartItem(product: product, quantity: quantity);
                return CartItemCard(item: item);
              }).toList(),
            ),
          ),

          CartSummary(
            totalItems: context.watch<CartProvider>().totalQuantity,
            totalPrice: context.read<CartProvider>().totalPrice(products),
            onCheckout: () {},
          ),
        ],
      ),
    );
  }
}
