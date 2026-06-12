import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/providers/product_provider.dart';

class NotFound extends StatefulWidget {
  const NotFound({Key? key}) : super(key: key);

  @override
  _NotFoundState createState() => _NotFoundState();
}

class _NotFoundState extends State<NotFound> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<ProductProvider>().refreshProducts();
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 80, color: Colors.grey),
              const SizedBox(height: 15),
              const Text(
                "No products found",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Try different keywords",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
