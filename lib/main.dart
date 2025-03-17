import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_appflowershop/controllers/category_controller.dart';
import 'package:frontend_appflowershop/views/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => CategoryController()..fetchCategories()),
      ],
      child: MaterialApp(
        title: 'Flower Shop',
        theme: ThemeData(primarySwatch: Colors.pink),
        home: HomeScreen(),
      ),
    );
  }
}
