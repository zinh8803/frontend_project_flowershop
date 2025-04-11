import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/views/screens/home_screen.dart';
import 'package:frontend_appflowershop/views/widgets/home/login_screen.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/category/category_bloc.dart';
import 'data/services/user/api_service.dart' as userApiService; 
import 'data/services/Category/api_category.dart' as categoryApiService; 
import 'data/repositories/auth_repository.dart';
import 'utils/preference_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userApi = userApiService.ApiService(); 
    final categoryApi = categoryApiService.ApiService(); 
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository(userApi)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(categoryApi),
          ),
        ],
        child: MaterialApp(
          home: FutureBuilder<String?>(
            future: PreferenceService().getToken(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasData && snapshot.data != null) {
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
