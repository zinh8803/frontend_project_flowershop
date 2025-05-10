import 'package:equatable/equatable.dart';

abstract class DiscountCheckEvent extends Equatable {
  const DiscountCheckEvent();

  @override
  List<Object> get props => [];
}

class CheckDiscountCode extends DiscountCheckEvent {
  final int id;
  final String discountCode;
  final double orderTotal;

  const CheckDiscountCode(
      {required this.id, required this.discountCode, required this.orderTotal});

  @override
  List<Object> get props => [discountCode, orderTotal];
}
