import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/cart/cart_bloc.dart';
import 'package:frontend_appflowershop/bloc/cart/cart_event.dart';
import 'package:frontend_appflowershop/bloc/cart/cart_state.dart';
import 'package:frontend_appflowershop/views/screens/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn muốn xóa sản phẩm này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Có'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<CartBloc>().add(LoadCartEvent());

    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        print('Current CartState: $state');
        if (state is CartInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CartLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CartLoaded) {
          final cartItems = state.cartItems;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Giỏ hàng của tui'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            body: cartItems.isEmpty
                ? const Center(child: Text('Giỏ hàng trống'))
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final cartItem = cartItems[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      cartItem.product.imageUrl,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          const Icon(Icons.image_not_supported,
                                              size: 80),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartItem.product.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${cartItem.product.finalPrice.toStringAsFixed(0)}đ',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (cartItem.size != null)
                                          Text(
                                              'Kích thước: ${cartItem.size!.name}'),
                                        if (cartItem.colors.isNotEmpty)
                                          Text(
                                              'Màu sắc: ${cartItem.colors.map((c) => c.name).join(', ')}'),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          context.read<CartBloc>().add(
                                                DecreaseQuantityEvent(
                                                  productId:
                                                      cartItem.product.id,
                                                  size: cartItem.size,
                                                  colors: cartItem.colors,
                                                ),
                                              );
                                        },
                                        icon: const Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        '${cartItem.quantity}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          context.read<CartBloc>().add(
                                                IncreaseQuantityEvent(
                                                  productId:
                                                      cartItem.product.id,
                                                  size: cartItem.size,
                                                  colors: cartItem.colors,
                                                ),
                                              );
                                        },
                                        icon: const Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.red),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          final shouldDelete =
                                              await _showDeleteConfirmationDialog(
                                                  context);
                                          if (shouldDelete == true) {
                                            context.read<CartBloc>().add(
                                                  RemoveFromCartEvent(
                                                    productId:
                                                        cartItem.product.id,
                                                    size: cartItem.size,
                                                    colors: cartItem.colors,
                                                  ),
                                                );
                                          }
                                        },
                                        icon: const Icon(Icons.delete_outline,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${state.totalItems} sản phẩm',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Tạm tính: ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '${state.totalPrice.toStringAsFixed(0)}đ',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CheckoutScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Tiến hành đặt hàng',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        }
        return const Center(child: Text('Có lỗi xảy ra'));
      },
    );
  }
}
