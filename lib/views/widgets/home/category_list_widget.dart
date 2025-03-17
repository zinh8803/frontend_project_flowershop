import 'package:flutter/material.dart';
import 'package:frontend_appflowershop/model/category.dart';
import 'package:frontend_appflowershop/views/widgets/home/CategoryCard.dart';

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
            crossAxisCount:
                2, // Sử dụng 2 cột để khớp với thiết kế Card của bạn
            childAspectRatio: 1.2, // Điều chỉnh tỷ lệ để Card hiển thị đẹp
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return CategoryCard(category: categories[index]);
          },
        ),
      ],
    );
  }
}
