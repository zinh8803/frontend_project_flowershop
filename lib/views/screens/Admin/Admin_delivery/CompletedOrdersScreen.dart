import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_completed/order_completed_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_completed/order_completed_event.dart';
import 'package:frontend_appflowershop/bloc/order/order_completed/order_completed_state.dart';
import 'package:frontend_appflowershop/bloc/order/order_detail/order_detail_bloc.dart';
import 'package:frontend_appflowershop/data/services/Order/api_order.dart';
import 'package:frontend_appflowershop/views/screens/Admin/Admin_screens/OrderDetailCompleteScreen.dart';
import 'package:frontend_appflowershop/views/screens/Admin/Admin_screens/OrderDetailProcessingScreen.dart';
import 'package:frontend_appflowershop/views/screens/order_detail_screen.dart';
import 'package:intl/intl.dart';

class CompletedOrdersScreen extends StatefulWidget {
  const CompletedOrdersScreen({super.key});

  @override
  State<CompletedOrdersScreen> createState() => _CompletedOrdersScreenState();
}

class _CompletedOrdersScreenState extends State<CompletedOrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderCompletedBloc>().add(FetchCompletedOrders());
  }

  Future<void> _refreshData() async {
    context.read<OrderCompletedBloc>().add(FetchCompletedOrders());
    // Đợi một chút để đảm bảo dữ liệu được tải
    await Future.delayed(const Duration(milliseconds: 2000));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: BlocBuilder<OrderCompletedBloc, OrderCompletedState>(
        builder: (context, state) {
          if (state is OrderCompletedLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderCompletedLoaded) {
            final orders = state.orders;

            if (orders.isEmpty) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: const Center(
                      child: Text('Không có đơn hàng đã hoàn thành')),
                ),
              );
            }
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
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
                            create: (context) => OrderDetailBloc(
                                context.read<ApiOrderService>()),
                            child: OrderDetailCompleteScreen(orderId: order.id),
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
          } else if (state is OrderCompletedError) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                child: Center(child: Text('load lại dữ liệu')),
              ),
            );
          }
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: const Center(child: Text('Không có dữ liệu')),
            ),
          );
        },
      ),
    );
  }
}
