import 'package:flutter/material.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';

class RegularEmployeeScreen extends StatelessWidget {
  const RegularEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhân Viên Thường'),
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
              'Chào mừng Nhân Viên Thường',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Thực hiện các nhiệm vụ cơ bản được giao.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
