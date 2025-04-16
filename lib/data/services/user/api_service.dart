import 'dart:convert';
import 'package:frontend_appflowershop/data/models/employee.dart';
import 'package:frontend_appflowershop/data/models/user.dart';
import 'package:frontend_appflowershop/utils/constants.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<dynamic> login(String email, String password) async {
    final String url = "${Constants.baseUrl}/login";
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final data = jsonData['data'];
      final token = jsonData['token'];
      if (data['position'] != null) {
        final employee = EmployeeModel.fromJson(data, token);
        print('Returning EmployeeModel: $employee');
        return employee;
      } else {
        final user = UserModel.fromJson(data, token);
        print('Returning UserModel: $user');
        return user;
      }
    } else {
      throw Exception('Đăng nhập thất bại: ${response.reasonPhrase}');
    }
  }

  Future<UserModel> register(String name, String email, String password) async {
    final String url = "${Constants.baseUrl}/register";
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    print('Register response: ${response.statusCode}, ${response.body}');
    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 201) {
        return UserModel.fromJson(jsonData['user'], jsonData['token']);
      } else {
        throw Exception('Đăng ký thất bại: ${jsonData['message']}');
      }
    } else if (response.statusCode == 422) {
      final jsonData = jsonDecode(response.body);
      throw Exception('Email đã tồn tại: ${jsonData['message']}');
    } else {
      throw ('Email đã tồn tại');
    }
  }

  Future<dynamic> getUserProfile() async {
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
        final json = jsonDecode(response.body);
        final data = json['data'];

        if (data['position'] != null) {
          final employee = EmployeeModel.fromJson(data, token);
          print('Returning EmployeeModel: $employee');
          return employee;
        } else {
          final user = UserModel.fromJson(data, token);
          print('Returning UserModel: $user');
          return user;
        }
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
