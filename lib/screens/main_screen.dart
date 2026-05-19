import 'package:flutter/material.dart';
import 'package:test_1/models/user_model.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';

class MainScreen extends StatefulWidget {
  final UserModel user;

  const MainScreen({super.key, required this.user});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = [HomeScreen(), ProfileScreen(user: widget.user), CartScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
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
