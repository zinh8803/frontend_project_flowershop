import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/discount/discount_check_bloc.dart';
import 'package:frontend_appflowershop/bloc/discount/discount_check_event.dart';
import 'package:frontend_appflowershop/bloc/discount/discount_check_state.dart';

class PromotionWidget extends StatefulWidget {
  const PromotionWidget({
    super.key,
    required this.orderTotal,
    required this.onDiscountApplied,
    required this.id, 
  });

  final double orderTotal;
  final Function(double newPrice, int discountId) onDiscountApplied;
  final int id; 

  @override
  State<PromotionWidget> createState() => _PromotionWidgetState();
}

class _PromotionWidgetState extends State<PromotionWidget> {
  final TextEditingController _couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DiscountCheckBloc, DiscountCheckState>(
      listener: (context, state) {
        if (state is DiscountCheckSuccess) {
          final discount = state.discountData;
          final value = discount.value;
          double newPrice = widget.orderTotal;

          if (discount.type == 'percentage') {
            newPrice = widget.orderTotal - (widget.orderTotal * value / 100);
          } else if (discount.type == 'fixed') {
            newPrice = widget.orderTotal - value;
          }

          if (newPrice < 0) newPrice = 0;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Áp dụng mã thành công: ${discount.type} (${discount.value}${discount.type == 'percentage' ? '%' : ' VNĐ'})',
              ),
            ),
          );

          widget.onDiscountApplied(newPrice, discount.id);
        } else if (state is DiscountCheckError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mã không hợp lệ: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Khuyến mãi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _couponController,
                    decoration: const InputDecoration(
                      hintText: 'Nhập mã khuyến mãi',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: state is DiscountCheckLoading
                      ? null
                      : () {
                          final code = _couponController.text.trim();
                          if (code.isNotEmpty) {
                            context.read<DiscountCheckBloc>().add(
                                  CheckDiscountCode(
                                    id: widget.id, // Sử dụng widget.id
                                    discountCode: code,
                                    orderTotal: widget.orderTotal,
                                  ),
                                );
                          }
                        },
                  child: state is DiscountCheckLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Áp dụng'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
