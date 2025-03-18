import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_appflowershop/controllers/category_controller.dart';
import '../widgets/home/header_banner_widget.dart';
import '../widgets/home/category_list_widget.dart';
import '../widgets/home/search_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: SearchBarWidget(),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.red),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderBannerWidget(),
            Consumer<CategoryController>(
              builder: (context, controller, child) {
                if (controller.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (controller.errorMessage != null) {
                  return Center(child: Text('Lỗi: ${controller.errorMessage}'));
                }
                if (controller.categories.isEmpty) {
                  return Center(child: Text('Không có danh mục nào'));
                }
                return Column(
                  children: [
                    CategoryListWidget(
                      title: 'Danh sách nhóm sản phẩm',
                      categories: controller.categories,
                    ),
                    CategoryListWidget(
                      title: 'Danh sách nhóm sản phẩm',
                      categories: controller.categories,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
