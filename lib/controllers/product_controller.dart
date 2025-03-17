import 'package:flutter/material.dart';
import 'package:frontend_appflowershop/model/product.dart';
import 'package:frontend_appflowershop/services/Product/api_product.dart';

class ProductController extends ChangeNotifier {
  final ApiService apiService = ApiService();
  List<ProductModel> _products = [];
  bool _isLoading = true;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  ProductController() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      _products = await apiService.getProducts();
    } catch (e) {
      print("Lỗi khi lấy sản phẩm: $e");
    }
    _isLoading = false;
    notifyListeners();
  }
}
