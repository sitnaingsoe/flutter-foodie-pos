import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_1/models/user_model.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profile"),
        backgroundColor: const Color.fromARGB(255, 40, 41, 42),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    setState(() {});
                  });
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
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

                          backgroundImage:
                              user!.image != null && user!.image!.isNotEmpty
                              ? NetworkImage(user!.image!)
                              : const AssetImage(
                                      'assets/images/default-image.jpg',
                                    )
                                    as ImageProvider,
                        ),
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            Text(
                              user!.firstName ?? "user name",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              user!.lastName ?? "user name",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
