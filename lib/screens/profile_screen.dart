import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_1/models/user_model.dart';
import 'package:test_1/screens/login_screen.dart';
import 'package:test_1/widgets/box.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("user") ?? '';
    if (userData.isNotEmpty) {
      setState(() {
        user = UserModel.fromJson(jsonDecode(userData));
      });
    } else {
      return;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profile"),
        backgroundColor: Colors.grey,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: logout,
                icon: const Icon(Icons.logout_sharp),
              ),
            ],
          ),
        ],
      ),
      body: user == null
          ? const CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsetsGeometry.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    padding: const EdgeInsets.only(top: 30, left: 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.white, Colors.grey],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 35, 27, 27),
                          blurRadius: 3,
                        ),
                      ],

                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: user!.image!.isNotEmpty
                                  ? NetworkImage(user!.image!)
                                  : const AssetImage(
                                          'assets/images/default-image.jpg',
                                        )
                                        as ImageProvider,
                            ),
                            const SizedBox(width: 20),
                            Text(
                              user!.username,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                  Container(
                    height: 160,
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 5, left: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Information ".toUpperCase(),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 45, 44, 44),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email :  " + user!.email,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "First Name :  " + user!.firstName,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Last Name :  " + user!.lastName,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Gender :  " + user!.gender,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 2000,
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        buildGridItem(Icons.favorite, "Favorite", Colors.red),
                        buildGridItem(
                          Icons.shopping_cart,
                          "Orders",
                          Colors.blue,
                        ),
                        buildGridItem(Icons.payment, "Payment", Colors.green),
                        buildGridItem(Icons.history, "History", Colors.orange),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
