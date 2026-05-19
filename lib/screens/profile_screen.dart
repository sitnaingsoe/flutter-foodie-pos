import 'package:flutter/material.dart';
import 'package:test_1/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                              widget.user.image != null &&
                                  widget.user.image!.isNotEmpty
                              ? NetworkImage(widget.user.image!)
                              : const AssetImage(
                                      'assets/images/default-image.jpg',
                                    )
                                    as ImageProvider,
                        ),
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            Text(
                              widget.user.firstName ?? "user name",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              widget.user.lastName ?? "user name",
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
