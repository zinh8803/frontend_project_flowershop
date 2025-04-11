import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:frontend_appflowershop/data/models/user.dart';
import 'package:frontend_appflowershop/utils/constants.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';
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

  Future<UserModel> getUserProfile() async {
    try {
      final token = await PreferenceService.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Fetching user profile from: ${Constants.baseUrl}/user/profile');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 200) {
          return UserModel.fromJson(jsonResponse['data'], token);
        } else {
          throw Exception('API returned error: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load user profile: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      final token = await PreferenceService.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Logout request to: ${Constants.baseUrl}/logout');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] != 200) {
          throw Exception('API returned error: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to logout: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }
}
