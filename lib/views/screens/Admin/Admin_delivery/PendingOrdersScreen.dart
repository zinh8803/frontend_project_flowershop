import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_detail/order_detail_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_pending/order_pending_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_pending/order_pending_event.dart';
import 'package:frontend_appflowershop/bloc/order/order_pending/order_pending_state.dart';
import 'package:frontend_appflowershop/data/services/Order/api_order.dart';
import 'package:frontend_appflowershop/views/screens/Admin/Admin_screens/OrderDetailPendingScreen.dart';
import 'package:frontend_appflowershop/views/screens/order_detail_screen.dart';
import 'package:intl/intl.dart';

class PendingOrdersScreen extends StatefulWidget {
  const PendingOrdersScreen({super.key});

  @override
  State<PendingOrdersScreen> createState() => _PendingOrdersScreenState();
}

class _PendingOrdersScreenState extends State<PendingOrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderPendingBloc>().add(FetchPendingOrders());
  }

  Future<void> _refreshData() async {
    context.read<OrderPendingBloc>().add(FetchPendingOrders());
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: BlocBuilder<OrderPendingBloc, OrderPendingState>(
        builder: (context, state) {
          if (state is OrderPendingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderPendingLoaded) {
            final orders = state.orders;

            if (orders.isEmpty) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: const Center(child: Text('Không có đơn hàng pending')),
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
                            child: OrderDetailPendingScreen(orderId: order.id),
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
          } else if (state is OrderPendingError) {
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
