import 'package:flutter/foundation.dart';
import 'package:frontend_appflowershop/data/models/category.dart';
import 'package:frontend_appflowershop/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response =
          await http.get(Uri.parse('${Constants.baseUrl}/categories'));

      print('Fetching categories from: ${Constants.baseUrl}/categories');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 200) {
          List<dynamic> data = jsonResponse['data'];
          return data.map((item) => CategoryModel.fromJson(item)).toList();
        } else {
          throw Exception('API returned error: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load categories: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow; 
    }
  }
}
