import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/cartitem_model.dart';
import 'package:test_1/providers/cart_provider.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.read<CartProvider>();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.product.thumbnail ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // ============= Details ====
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "\$${item.product.price}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          cartProvider.decreaseQty(item.product);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.remove, size: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        item.quantity.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),

                      GestureDetector(
                        onTap: () {
                          cartProvider.increaseQty(item.product);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.add, size: 18),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          cartProvider.removeFromCart(item.product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${item.product.title} removed from cart",
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete_outline,
                        color: Colors.red,),
                      ),
                    ],
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
