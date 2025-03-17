import 'package:flutter/material.dart';
import 'package:frontend_appflowershop/model/category.dart';
import 'category_widget.dart'; // Sử dụng CategoryWidget thay vì CategoryCard

class CategoryListWidget extends StatelessWidget {
  final String title;
  final List<CategoryModel> categories;

  CategoryListWidget({required this.title, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 4 danh mục trên 1 hàng
            childAspectRatio: 0.8, // Tỷ lệ chiều cao/chiều rộng
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return CategoryWidget(category: categories[index]);
          },
        ),
      ],
    );
  }
}
