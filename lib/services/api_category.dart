import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend_appflowershop/model/category.dart';
import 'package:frontend_appflowershop/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // static const String baseUrl = "http://10.0.2.2:8000/api";

  Future<List<CategoryModel>> getCategories() async {
    final response =
        await http.get(Uri.parse('${Constants.baseUrl}/categories'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 200) {
        List<dynamic> data = jsonResponse['data'];
        return data.map((item) => CategoryModel.fromJson(item)).toList();
      } else {
        throw Exception('API returned error: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
