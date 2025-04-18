import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_detail/order_detail_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_get_user/order_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_get_user/order_event.dart';
import 'package:frontend_appflowershop/bloc/order/order_get_user/order_state.dart';
import 'package:frontend_appflowershop/data/services/Order/api_order.dart';
import 'package:frontend_appflowershop/views/screens/order_detail_screen.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(FetchUserOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng của tui'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderLoaded) {
            final orders = state.orders;

            if (orders.isEmpty) {
              return const Center(child: Text('Bạn chưa có đơn hàng nào.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final formattedDate = DateFormat('yyyy-MM-dd HH:mm')
                    .format(DateTime.parse(order.createdAt));
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => OrderDetailBloc(
                                context.read<ApiOrderService>()),
                            child: OrderDetailScreen(orderId: order.id),
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Đơn hàng #${order.id}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                              'Tổng giá: ${order.totalPrice.toStringAsFixed(0)}đ'),
                          Text('Trạng thái: ${order.status}'),
                          Text('Ngày mua: ${formattedDate}'),
                          const SizedBox(height: 8),
                          // const Text(
                          //   'Sản phẩm:',
                          //   style: TextStyle(fontWeight: FontWeight.bold),
                          // ),
                          // ...order.orderItems.map((item) => ListTile(
                          //       title: Text('Sản phẩm ID: ${item.productId}'),
                          //       subtitle: Text(
                          //           'Số lượng: ${item.quantity} - Giá: ${item.price.toStringAsFixed(0)}đ'),
                          //     )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is OrderError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
