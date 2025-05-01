import 'package:flutter/material.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';

class AdminFlowerServiceScreen extends StatelessWidget {
  const AdminFlowerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Phục Vụ Hoa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              PreferenceService.clearToken().then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đăng xuất thành công')),
                );
              });
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Chào mừng Admin Phục Vụ Hoa',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Quản lý sản phẩm và danh mục hoa.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
