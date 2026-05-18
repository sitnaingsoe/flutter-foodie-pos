import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_1/models/user_model.dart';



class ApiService {
  static Future<UserModel?> login({
    required String username,
    required String password,
  })async{
     final url = Uri.parse('https://dummyjson.com/auth/login');
     final response = await http.post(url, headers: {
     'Content-Type':'application/json',
     },
     body: jsonEncode({
      "username":username,
      "password":password
     }),);
     if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
     }else{
      return null;
     } 
  }
}