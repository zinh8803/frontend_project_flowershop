import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_detail/order_detail_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_processing/order_processing_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_processing/order_processing_event.dart';
import 'package:frontend_appflowershop/bloc/order/order_processing/order_processing_state.dart';

import 'package:frontend_appflowershop/data/services/Order/api_order.dart';
import 'package:frontend_appflowershop/views/screens/Admin/Admin_screens/OrderDetailProcessingScreen.dart';
import 'package:frontend_appflowershop/views/screens/order_detail_screen.dart';
import 'package:intl/intl.dart';

class ProcessingOrdersScreen extends StatefulWidget {
  const ProcessingOrdersScreen({super.key});

  @override
  State<ProcessingOrdersScreen> createState() => _ProcessingOrdersScreenState();
}

class _ProcessingOrdersScreenState extends State<ProcessingOrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderProcessingBloc>().add(FetchProcessingOrders());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderProcessingBloc, OrderProcessingState>(
      builder: (context, state) {
        if (state is OrderProcessingLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OrderProcessingLoaded) {
          final orders = state.orders;

          if (orders.isEmpty) {
            return const Center(child: Text('Không có đơn hàng đang giao'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final formattedDate = DateFormat('yyyy-MM-dd HH:mm')
                  .format(DateTime.parse(order.createdAt));
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) =>
                              OrderDetailBloc(context.read<ApiOrderService>()),
                          child: OrderDetailProcessingScreen(orderId: order.id),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đơn hàng #${order.id}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'Tổng: ${order.totalPrice.toStringAsFixed(0)}đ'),
                            Text('Ngày: ${formattedDate}'),
                          ],
                        ),
                        Text('Trạng thái: ${order.status}'),
                        Text('Địa chỉ: ${order.address}'),
                        Text('SĐT: ${order.phoneNumber}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is OrderProcessingError) {
          return Center(child: Text('Lỗi: ${state.message}'));
        }
        return const SizedBox();
      },
    );
  }
}
