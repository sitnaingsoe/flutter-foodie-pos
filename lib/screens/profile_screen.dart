import 'package:flutter/material.dart';
import 'package:test_1/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profile"),
        backgroundColor: const Color.fromARGB(255, 90, 147, 247),
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
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(31, 169, 145, 145),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            widget.user.image ?? '',
                          ),
                        ),
                        Text(
                          widget.user.firstName ?? "sdfsdfdfdfgd",
                          style: TextStyle(color: Colors.amber, fontSize: 20),
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
