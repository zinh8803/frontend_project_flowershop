import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:frontend_appflowershop/data/models/user.dart';
import 'package:frontend_appflowershop/utils/constants.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<UserModel> login(String email, String password) async {
    final String url = "${Constants.baseUrl}/login";
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return UserModel.fromJson(jsonData['data'], jsonData['token']);
    } else {
      throw Exception('Đăng nhập thất bại: ${response.reasonPhrase}');
    }
  }
}
