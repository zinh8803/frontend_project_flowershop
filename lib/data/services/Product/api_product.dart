import 'dart:convert';
import 'package:frontend_appflowershop/data/models/product.dart';
import 'package:frontend_appflowershop/utils/constants.dart';
import 'package:http/http.dart' as http;

class ApiService_product {
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/products/search?query=$query'),
      );

      print('Searching products with query: $query');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 200) {
          List<dynamic> productsJson = jsonResponse['data'];
          return productsJson
              .map((json) => ProductModel.fromJson(json))
              .toList();
        } else {
          throw Exception('API returned error: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to search products: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error searching products: $e');
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductsdiscount() async {
    final String url = "${Constants.baseUrl}/discount-product";
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

  Future<ProductModel> getProductDetail(int productId) async {
    try {
      final response =
          await http.get(Uri.parse('${Constants.baseUrl}/products/$productId'));

      print(
          'Fetching product detail from: ${Constants.baseUrl}/products/$productId');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 200) {
          return ProductModel.fromJson(jsonResponse['data']);
        } else {
          throw Exception('API returned error: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load product detail: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching product detail: $e');
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/products/category/$categoryId'),
      );

      print(
          'Fetching products by category from: ${Constants.baseUrl}/products/category/$categoryId');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 200) {
          List<dynamic> productsJson = jsonResponse['data'];
          return productsJson
              .map((json) => ProductModel.fromJson(json))
              .toList();
        } else {
          throw Exception('API returned error: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load products by category: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching products by category: $e');
      rethrow;
    }
  }
}
