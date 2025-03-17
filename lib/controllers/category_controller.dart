import 'package:flutter/material.dart';
import 'package:frontend_appflowershop/model/category.dart';
import 'package:frontend_appflowershop/services/Category/api_category.dart';

class CategoryController with ChangeNotifier {
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage; // Biến lưu lỗi

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final ApiService _apiService = ApiService();

  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null; // Reset lỗi
    notifyListeners();

    try {
      _categories = await _apiService.getCategories();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error in CategoryController: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
