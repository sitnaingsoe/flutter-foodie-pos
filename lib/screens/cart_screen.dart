import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/providers/counter_provider.dart';
// import '../models/product_model.dart';

class CartScreen extends StatefulWidget {
  // final List<Product> cartProducts;

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // double get totalPrice {
  //   return widget.cartProducts.fold(0, (sum, item) => sum + (item.price ?? 0));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Provider Example ")),

      body: Container(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            Text("hello", style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<CounterProvider>().decreasement();
                    },
                    child: Text("decrease"),
                  ),
                  const SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CounterProvider>().increment();
                    },
                    child: Text("increase"),
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
