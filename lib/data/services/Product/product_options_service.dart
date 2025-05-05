import 'package:frontend_appflowershop/data/models/size.dart';
import 'package:frontend_appflowershop/data/models/color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend_appflowershop/utils/constants.dart';

class ProductOptionsService {
  static final ProductOptionsService _instance =
      ProductOptionsService._internal();
  factory ProductOptionsService() => _instance;
  ProductOptionsService._internal();

  List<SizeModel> _sizes = [];
  List<ColorModel> _colors = [];
  bool _isLoading = false;
  String? _error;

  Future<void> fetchOptions(int productId) async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;

    try {
      final data = await getProductOptions(productId);
      _sizes = (data['sizes'] as List)
          .map((json) => SizeModel.fromJson(json))
          .toList();
      _colors = (data['colors'] as List)
          .map((json) => ColorModel.fromJson(json))
          .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
  }

  Future<Map<String, dynamic>> getProductOptions(int productId) async {
    print(
        'Fetching product options from: ${Constants.baseUrl}/products/$productId/options');
    print('Product ID: $productId');
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/products/$productId/options'),
      headers: {'Accept': 'application/json'},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception(
          'Không thể lấy danh sách tùy chọn: ${response.statusCode}');
    }
  }

  List<SizeModel> get sizes => _sizes;
  List<ColorModel> get colors => _colors;
  bool get isLoading => _isLoading;
  String? get error => _error;
}
