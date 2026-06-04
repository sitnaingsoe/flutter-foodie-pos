import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show ReadContext;
import 'package:test_1/providers/product_provider.dart';
import 'products_screen.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int currentIndex;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;

    screens = [ProductsScreen(),  ProfileScreen(),  CartScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index != 0) {
            context.read<ProductProvider>().clearSearch();
          }

          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Order',
          ),
        ],
      ),
    );
  }
}
