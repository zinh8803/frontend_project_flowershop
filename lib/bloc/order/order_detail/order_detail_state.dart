import 'package:equatable/equatable.dart';
import 'package:frontend_appflowershop/data/models/ordergetuser.dart';

abstract class OrderDetailState extends Equatable {
  const OrderDetailState();

  @override
  List<Object> get props => [];
}

class OrderDetailInitial extends OrderDetailState {}

class OrderDetailLoading extends OrderDetailState {}

class OrderDetailUpdating extends OrderDetailState {}

class OrderDetailLoaded extends OrderDetailState {
  final OrdergetuserModel orders;

  const OrderDetailLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderDetailError extends OrderDetailState {
  final String message;

  OrderDetailError(this.message);
}
