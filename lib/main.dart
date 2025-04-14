import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/category/category_product/category_products_bloc.dart';
import 'package:frontend_appflowershop/bloc/checkout/checkout_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/product_list/product_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/product_list_discount/product_list_discount_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/sreach_product/sreach_bloc.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_bloc.dart';
import 'package:frontend_appflowershop/data/services/cart/cart_service.dart';
import 'package:frontend_appflowershop/views/screens/home_screen.dart';
import 'package:frontend_appflowershop/views/screens/login_screen.dart';
import 'bloc/auth/Login/auth_bloc.dart';
import 'package:frontend_appflowershop/bloc/cart/cart_bloc.dart';
import 'bloc/category/category_bloc.dart';
import 'data/services/user/api_service.dart' as userApiService;
import 'data/services/Category/api_category.dart' as categoryApiService;
import 'data/services/Product/api_product.dart' as productApiService;
import 'data/services/Order/api_order.dart' as orderApiService;
import 'utils/preference_service.dart';
import 'bloc/product/product_detail/product_detail_bloc.dart';
import 'package:frontend_appflowershop/views/screens/checkout_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<bool> _checkTokenAndUser() async {
    try {
      // Lấy token từ PreferenceService
      final token = await PreferenceService.getToken();
      if (token == null) {
        print('No token found');
        return false;
      }

      final apiService = userApiService.ApiService();
      await apiService.getUserProfile();
      print('Token is valid, user profile fetched successfully');
      return true;
    } catch (e) {
      print('Error checking token: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userApi = userApiService.ApiService();
    final categoryApi = categoryApiService.ApiService();
    final productApi = productApiService.ApiService_product();
    final cartService = CartService();
    final orderService = orderApiService.ApiOrderService();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => userApi),
        RepositoryProvider(create: (context) => cartService),
        RepositoryProvider(create: (context) => categoryApi),
        RepositoryProvider(create: (context) => productApi),
        RepositoryProvider(create: (context) => orderService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(context.read<userApiService.ApiService>()),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(categoryApi),
          ),
          BlocProvider(
            create: (context) => ProductBloc(productApi),
          ),
          BlocProvider(
            create: (context) => ProductListDiscountBloc(productApi),
          ),
          BlocProvider(
            create: (context) => ProductDetailBloc(productApi),
          ),
          BlocProvider(
            create: (context) => CategoryProductsBloc(productApi),
          ),
          BlocProvider(
            create: (context) => UserProfileBloc(userApi, PreferenceService()),
          ),
          BlocProvider(
            create: (context) => SearchBloc(productApi),
          ),
          BlocProvider(
            create: (context) => CartBloc(context.read<CartService>()),
          ),
          BlocProvider(
            create: (context) => CheckoutBloc(orderService),
          ),
        ],
        child: MaterialApp(
          home: FutureBuilder<bool>(
            future: _checkTokenAndUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasData && snapshot.data == true) {
                return const HomeScreen();
              }
              return const LoginScreen();
            },
          ),
        ),
      ),
    );
  }
}
