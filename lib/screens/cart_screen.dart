import 'package:flutter/material.dart';
// import '../models/product_model.dart';

class CartScreen extends StatefulWidget {
  // final List<Product> cartProducts;

  // const CartScreen({super.key, required this.cartProducts});

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
      appBar: AppBar(title: const Text("My Cart")),

      // body: widget.cartProducts.isEmpty
      //     ? const Center(child: Text("Cart is empty"))
      //     : Column(
      //         children: [
      //           Expanded(
      //             child: ListView.builder(
      //               itemCount: widget.cartProducts.length,

      //               itemBuilder: (context, index) {
      //                 final product = widget.cartProducts[index];

      //                 return Card(
      //                   margin: const EdgeInsets.all(10),

      //                   child: ListTile(
      //                     leading: Image.network(
      //                       product.images?.first ?? '',
      //                       width: 60,
      //                       fit: BoxFit.cover,
      //                     ),

      //                     title: Text(product.title),

      //                     subtitle: Text("\$${product.price}"),

      //                     trailing: IconButton(
      //                       icon: const Icon(Icons.delete, color: Colors.red),

      //                       onPressed: () {
      //                         setState(() {
      //                           widget.cartProducts.removeAt(index);
      //                         });

      //                         ScaffoldMessenger.of(context).showSnackBar(
      //                           SnackBar(
      //                             content: Text("${product.title} removed"),
      //                           ),
      //                         );
      //                       },
      //                     ),
      //                   ),
      //                 );
      //               },
      //             ),
      //           ),

      //           Container(
      //             padding: const EdgeInsets.all(16),

      //             decoration: BoxDecoration(
      //               color: Colors.white,
      //               boxShadow: [
      //                 BoxShadow(color: Colors.black12, blurRadius: 10),
      //               ],
      //             ),

      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,

      //               children: [
      //                 Text(
      //                   "Total: \$${totalPrice.toStringAsFixed(2)}",
      //                   style: const TextStyle(
      //                     fontSize: 18,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 ),

      //                 ElevatedButton(
      //                   onPressed: () {
      //                     ScaffoldMessenger.of(context).showSnackBar(
      //                       const SnackBar(
      //                         content: Text("Checkout not implemented"),
      //                       ),
      //                     );
      //                   },

      //                   child: const Text("Checkout"),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
    );
  }
}
