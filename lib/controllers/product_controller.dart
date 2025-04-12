import 'package:flutter/material.dart';
import 'package:frontend_appflowershop/data/models/product.dart';
import 'package:frontend_appflowershop/data/services/Product/api_product.dart';

class ProductController extends ChangeNotifier {
  final ApiService_product apiService = ApiService_product();
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
