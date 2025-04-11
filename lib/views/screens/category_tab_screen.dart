import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/category/category_product/category_products_bloc.dart';
import 'package:frontend_appflowershop/bloc/category/category_product/category_products_event.dart';
import 'package:frontend_appflowershop/bloc/category/category_product/category_products_state.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category/category_state.dart';

import '../../data/models/category.dart';
import '../widgets/category_products/product_widget.dart';

class CategoryTabScreen extends StatefulWidget {
  const CategoryTabScreen({super.key});

  @override
  State<CategoryTabScreen> createState() => _CategoryTabScreenState();
}

class _CategoryTabScreenState extends State<CategoryTabScreen> {
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Lấy danh sách danh mục
    context.read<CategoryBloc>().add(FetchCategoriesEvent());
  }

  void _onCategorySelected(CategoryModel category) {
    setState(() {
      _selectedCategory = category;
    });
    // Lấy danh sách sản phẩm của danh mục được chọn
    context
        .read<CategoryProductsBloc>()
        .add(FetchCategoryProductsEvent(category.id));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Danh sách danh mục bên trái
        Container(
          width: 100, // Chiều rộng cố định cho danh sách danh mục
          color: Colors.grey[200],
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is CategoryError) {
                return Center(child: Text('Lỗi: ${state.message}'));
              }
              if (state is CategoryLoaded) {
                if (state.categories.isEmpty) {
                  return const Center(child: Text('Không có danh mục'));
                }
                return ListView.builder(
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    final isSelected = _selectedCategory?.id == category.id;
                    return GestureDetector(
                      onTap: () => _onCategorySelected(category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        color: isSelected ? Colors.white : Colors.grey[200],
                        child: Text(
                          category.name,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.black : Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
        // Danh sách sản phẩm bên phải
        Expanded(
          child: BlocBuilder<CategoryProductsBloc, CategoryProductsState>(
            builder: (context, state) {
              if (_selectedCategory == null) {
                return const Center(child: Text('Vui lòng chọn danh mục'));
              }
              if (state is CategoryProductsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is CategoryProductsError) {
                return Center(child: Text('Lỗi: ${state.message}'));
              }
              if (state is CategoryProductsLoaded) {
                if (state.products.isEmpty) {
                  return const Center(
                      child: Text('Không có sản phẩm nào trong danh mục này'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 cột
                    crossAxisSpacing: 16, // Khoảng cách ngang giữa các sản phẩm
                    mainAxisSpacing: 16, // Khoảng cách dọc giữa các sản phẩm
                    childAspectRatio:
                        0.7, // Tỷ lệ chiều rộng/chiều cao của mỗi sản phẩm
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    return ProductWidget(product: state.products[index]);
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
