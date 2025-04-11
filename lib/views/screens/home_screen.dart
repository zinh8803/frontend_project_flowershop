import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/category/category_bloc.dart';
import 'package:frontend_appflowershop/bloc/category/category_event.dart';
import 'package:frontend_appflowershop/bloc/category/category_state.dart';
import 'package:provider/provider.dart';
import 'package:frontend_appflowershop/controllers/category_controller.dart';
import '../widgets/home/header_banner_widget.dart';
import '../widgets/home/category_list_widget.dart';
import '../widgets/home/search_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Gửi sự kiện FetchCategoriesEvent khi HomeScreen được khởi tạo
    context.read<CategoryBloc>().add(FetchCategoriesEvent());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: SearchBarWidget(),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.red),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderBannerWidget(),
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CategoryError) {
                  return Center(child: Text('Lỗi: ${state.message}'));
                }
                if (state is CategoryLoaded) {
                  if (state.categories.isEmpty) {
                    return const Center(child: Text('Không có danh mục nào'));
                  }
                  return Column(
                    children: [
                      CategoryListWidget(
                        title: 'Danh sách nhóm sản phẩm',
                        categories: state.categories,
                      ),
                    ],
                  );
                }
                return const SizedBox(); // Trạng thái ban đầu (CategoryInitial)
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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
