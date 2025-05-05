import 'package:flutter/material.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';
import 'package:frontend_appflowershop/views/screens/Admin/Admin_delivery/CompletedOrdersScreen.dart';
import 'package:frontend_appflowershop/views/screens/Admin/Admin_delivery/PendingOrdersScreen.dart';
import 'package:frontend_appflowershop/views/screens/Admin/Admin_delivery/ProcessingOrdersScreen.dart';

class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nhân Viên Giao Hàng'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                PreferenceService.clearToken().then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đăng xuất thành công')),
                  );
                  Navigator.pushReplacementNamed(context, '/login');
                });
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Processing'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PendingOrdersScreen(),
            ProcessingOrdersScreen(),
            CompletedOrdersScreen(),
          ],
        ),
      ),
    );
  }
}
