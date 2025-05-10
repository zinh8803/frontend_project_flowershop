import 'package:equatable/equatable.dart';
import 'package:frontend_appflowershop/data/models/discount_check_model.dart';

abstract class DiscountCheckState extends Equatable {
  const DiscountCheckState();

  @override
  List<Object> get props => [];
}

class DiscountCheckInitial extends DiscountCheckState {}

class DiscountCheckLoading extends DiscountCheckState {}

class DiscountCheckSuccess extends DiscountCheckState {
  final DiscountData discountData;
  final double discountedPrice; 

  const DiscountCheckSuccess(
      {required this.discountData, required this.discountedPrice});

  @override
  List<Object> get props => [discountData, discountedPrice];
}

class DiscountCheckError extends DiscountCheckState {
  final String message;

  const DiscountCheckError({required this.message});

  @override
  List<Object> get props => [message];
}
