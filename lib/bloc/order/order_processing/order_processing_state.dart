import 'package:equatable/equatable.dart';
import 'package:frontend_appflowershop/data/models/ordergetuser.dart';

abstract class OrderProcessingState extends Equatable {
  const OrderProcessingState();

  @override
  List<Object> get props => [];
}

class OrderProcessingInitial extends OrderProcessingState {}

class OrderProcessingLoading extends OrderProcessingState {}

class OrderProcessingLoaded extends OrderProcessingState {
  final List<OrdergetuserModel> orders;

  const OrderProcessingLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderProcessingError extends OrderProcessingState {
  final String message;

  const OrderProcessingError(this.message);

  @override
  List<Object> get props => [message];
}
