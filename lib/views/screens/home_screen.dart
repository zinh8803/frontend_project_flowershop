import 'package:flutter/material.dart';
import 'package:frontend_appflowershop/controllers/category_controller.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flower Shop'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.red),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<CategoryController>(
        builder: (context, categoryController, _) {
          if (categoryController.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: categoryController.categories.length,
            itemBuilder: (context, index) {
              final category = categoryController.categories[index];
              return ListTile(
                title: Text(category.name),
                leading: Image.network(
                  category.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.broken_image,
                        size: 50, color: Colors.red);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
