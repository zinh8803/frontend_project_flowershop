import 'package:flutter/material.dart';
import '../../../data/models/category.dart';
import '../../screens/category_products_screen.dart';

class CategoryListWidget extends StatelessWidget {
  final String title;
  final List<CategoryModel> categories;

  const CategoryListWidget(
      {super.key, required this.title, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () {
                    // Điều hướng đến CategoryProductsScreen khi bấm vào danh mục
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProductsScreen(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          category.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
