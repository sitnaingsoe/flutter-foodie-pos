import 'package:flutter/material.dart';
import 'package:test_1/screens/main_screen.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_1/models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
final TextEditingController usernameController = TextEditingController(text: 'emilys');
final TextEditingController passwordController = TextEditingController(text: 'emilyspass');

bool isLoading = false;

Future<void> login() async{
  setState(() {
    isLoading = true;
  });
    final url = Uri.parse('https://dummyjson.com/auth/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": usernameController.text,
          "password": passwordController.text,
        }),
      );
      if(response.statusCode == 200){          
          Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (_) => MainScreen()),
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:Padding(
      padding: const EdgeInsets.all(10),
      child:Column(
      children: [
            Center(
                child: Column(
                  children: const [
                    Icon(Icons.lock, size: 80, color: Colors.blue),
                    SizedBox(height: 10),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
        const SizedBox(height: 20,),
              TextField(
               controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: const Icon(Icons.person,color: Colors.blue),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 0, 0, 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ), 
              const SizedBox(height: 20,),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock,color: Colors.blue,),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 1, 1, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
                SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

      ],
     )),
    

    );
  }
}