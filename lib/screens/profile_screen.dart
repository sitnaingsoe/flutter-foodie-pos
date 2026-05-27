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
    await prefs.remove('accessToken');
    await prefs.remove("refreshToken");
    await prefs.remove("user");
    await prefs.remove("expiryTime");
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profile"),

        actions: [
          Stack(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
            ],
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsetsGeometry.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      padding: const EdgeInsets.only(top: 30, left: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(color: Colors.white, blurRadius: 3),
                        ],

                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: user!.image.isNotEmpty
                                    ? NetworkImage(user!.image)
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
                      height: 210,
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 5, left: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                        boxShadow: const [
                          BoxShadow(color: Colors.white, blurRadius: 3),
                        ],
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
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email : ${user!.email} ",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "First Name :  ${user!.firstName}",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "Last Name :  ${user!.lastName}",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "Gender :  ${user!.gender}",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 1.5,
                        children: [
                          buildGridItem(Icons.favorite, "Favorite", Colors.red),
                          buildGridItem(
                            Icons.shopping_cart,
                            "Orders",
                            Colors.blue,
                          ),
                          buildGridItem(Icons.payment, "Payment", Colors.green),
                          buildGridItem(
                            Icons.history,
                            "History",
                            Colors.orange,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 140,
                      width: double.infinity,

                      padding: const EdgeInsets.only(top: 5, left: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.white),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 174, 176, 174),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "General".toUpperCase(),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 45, 44, 44),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.help,
                                        color: Color.fromARGB(
                                          255,
                                          113,
                                          112,
                                          112,
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Text(
                                        "Help",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.security,
                                        color: Color.fromARGB(
                                          255,
                                          113,
                                          112,
                                          112,
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Text(
                                        "Privacy & Policy",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: logout,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
