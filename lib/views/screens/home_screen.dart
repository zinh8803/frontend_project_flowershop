import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/product_list/product_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/product_list/product_event.dart';
import 'package:frontend_appflowershop/bloc/product/product_list/product_state.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category/category_state.dart';

import '../widgets/home/header_banner_widget.dart';
import '../widgets/home/category_list_widget.dart';
import '../widgets/home/product_list_widget.dart';
import '../widgets/home/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(FetchCategoriesEvent());
    context.read<ProductBloc>().add(FetchProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:  SearchBarWidget(),
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
              builder: (context, categoryState) {
                if (categoryState is CategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (categoryState is CategoryError) {
                  return Center(child: Text('Lỗi: ${categoryState.message}'));
                }
                if (categoryState is CategoryLoaded) {
                  if (categoryState.categories.isEmpty) {
                    return const Center(child: Text('Không có danh mục nào'));
                  }
                  return Column(
                    children: [
                      CategoryListWidget(
                        title: 'Danh sách danh mục sản phẩm',
                        categories: categoryState.categories,
                      ),
                      BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, productState) {
                          if (productState is ProductLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (productState is ProductError) {
                            return Center(
                                child: Text('Lỗi: ${productState.message}'));
                          }
                          if (productState is ProductLoaded) {
                            if (productState.products.isEmpty) {
                              return const Center(
                                  child: Text('Không có sản phẩm nào'));
                            }
                            return ProductListWidget(
                              title: 'Danh sách sản phẩm hôm nay',
                              products: productState.products,
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: ''),
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
