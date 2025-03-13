import 'package:flutter/material.dart';
import 'package:frontend_appflowershop/model/category.dart';
import 'package:frontend_appflowershop/services/api_category.dart';

class CategoryController with ChangeNotifier {
  List<CategoryModel> _categories = [];
  bool _isLoading = false;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;

  final ApiService _apiService = ApiService();

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _apiService.getCategories();
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }
}
