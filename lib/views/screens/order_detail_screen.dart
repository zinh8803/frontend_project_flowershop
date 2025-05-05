import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_detail/order_detail_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_detail/order_detail_event.dart';
import 'package:frontend_appflowershop/bloc/order/order_detail/order_detail_state.dart';
import 'package:frontend_appflowershop/data/models/ordergetuser.dart';
import 'package:frontend_appflowershop/data/services/Product/product_options_service.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final ProductOptionsService _optionsService = ProductOptionsService();
  @override
  void initState() {
    super.initState();
    context.read<OrderDetailBloc>().add(FetchOrderDetail(widget.orderId));
  }

  String _getSizeName(OrderItemModel item) {
    try {
      final size = _optionsService.sizes.firstWhere((s) => s.id == item.sizeId);
      return size.name;
    } catch (e) {
      return 'Không xác định';
    }
  }

  String _getColorName(OrderItemModel item) {
    if (item.colors != null && item.colors!.isNotEmpty) {
      try {
        return item.colors!.whereType<int>().map((colorId) {
          final color =
              _optionsService.colors.firstWhere((c) => c.id == colorId);
          return color.name;
        }).join(', ');
      } catch (e) {
        return 'Không xác định';
      }
    }
    print('Item colors: ${item.colors}');
    return 'Không có màu';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<OrderDetailBloc, OrderDetailState>(
        builder: (context, state) {
          if (state is OrderDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderDetailLoaded) {
            final order = state.orders;
            final formattedDate = DateFormat('yyyy-MM-dd HH:mm')
                .format(DateTime.parse(order.createdAt));
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đơn hàng #${order.id}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                      'Tổng giá', '${order.totalPrice.toStringAsFixed(0)}đ'),
                  _buildInfoRow('Trạng thái', order.status),
                  _buildInfoRow('Ngày mua', formattedDate),
                  _buildInfoRow('Người nhận', order.name),
                  _buildInfoRow('Email', order.email),
                  _buildInfoRow('Số điện thoại', order.phoneNumber),
                  _buildInfoRow('Địa chỉ', order.address),
                  _buildInfoRow('Phương thức thanh toán', order.paymentMethod),
                  const SizedBox(height: 16),
                  const Text(
                    'Sản phẩm:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  ...order.orderItems.map((item) => Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: item.product?.imageUrl != null
                              ? Image.network(
                                  '${item.product!.imageUrl}',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error),
                                )
                              : const Icon(Icons.image_not_supported),
                          title: Text(item.product?.name ??
                              'Sản phẩm ID: ${item.productId}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Số lượng: ${item.quantity}'),
                              Text('Kích thước: ${_getSizeName(item)}'),
                              Text('Màu sắc: ${_getColorName(item)}'),
                              //Text('Giá: ${item.price.toStringAsFixed(0)}đ'),
                              // if (item.product?.description != null)
                              //   Text('Mô tả: ${item.product!.description}'),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            );
          } else if (state is OrderDetailError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
