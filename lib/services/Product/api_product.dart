import 'dart:convert';
import 'package:frontend_appflowershop/model/product.dart';
import 'package:frontend_appflowershop/utils/constants.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<ProductModel>> getProducts() async {
    final String url = "${Constants.baseUrl}${Constants.flowersEndpoint}";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 200) {
          return (jsonResponse['data'] as List)
              .map((item) => ProductModel.fromJson(item))
              .toList();
        } else {
          throw Exception("Lỗi API: ${jsonResponse['message']}");
        }
      } else {
        throw Exception("Lỗi kết nối: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Lỗi: $e");
    }
  }
}
