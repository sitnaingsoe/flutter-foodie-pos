import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/providers/cart_provider.dart';
import 'package:test_1/widgets/cart_summary.dart';
import 'package:test_1/widgets/cart_item_card.dart';

class CartScreen extends StatefulWidget {
  // final List<Product> cartProducts;

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {


  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartProvider.items.length,
                itemBuilder: (context, index) {
                  final item = cartProvider.items[index];
                  return CartItemCard(item: item);
                },
              ),
            ),
            CartSummary(
              totalItems: cartProvider.totalItems,
              totalPrice: cartProvider.totalPrice,
              onCheckout: () {},
            ),
          ],
        ),
      ),
    );
  }
}
