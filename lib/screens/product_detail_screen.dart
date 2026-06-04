import 'package:flutter/material.dart';
import 'package:test_1/screens/home_screen.dart';
import '../models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/product_model.dart';
import 'package:test_1/providers/cart_provider.dart';
import 'package:test_1/providers/favorite_provider.dart';
import 'package:test_1/widgets/add_to_cart_button.dart';
import 'package:test_1/widgets/favorite_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavoriteProvider>();
    final isFavorite = favoriteProvider.isFavorite(widget.product.id);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(widget.product.title),
        actions: [
          IconButton(
            onPressed: () {
              favoriteProvider.toggleFavorite(widget.product.id);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: isFavorite
                      ? const Color.fromARGB(255, 184, 10, 10)
                      : const Color.fromARGB(255, 8, 8, 8),
                  content: Text(
                    isFavorite
                        ? "${widget.product.title} removed from favorites"
                        : "${widget.product.title} add to favorites",
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            icon: Icon(Icons.favorite),
            color: isFavorite
                ? const Color.fromARGB(255, 197, 9, 9)
                : Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.product.images?.first ?? '',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            // product context
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.all(12),
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
                    Center(
                      child: Column(
                        children: [
                          Text(
                            widget.product.title,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 20,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${widget.product.rating}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "( reviews )",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${widget.product.price}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 17, 131, 21),
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (quantity > 1) {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.remove),
                              ),
                            ),
                            const SizedBox(width: 15),

                            Text(
                              "$quantity",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 15),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    const SizedBox(height: 15),
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.product.description,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: \$${(widget.product.price! * quantity).toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              // Add to cart button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeScreen(initialIndex: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                child: const Text("Buy Now"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
