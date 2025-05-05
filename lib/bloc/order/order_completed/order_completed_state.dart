import 'package:equatable/equatable.dart';
import 'package:frontend_appflowershop/data/models/ordergetuser.dart';

abstract class OrderCompletedState extends Equatable {
  const OrderCompletedState();

  @override
  List<Object> get props => [];
}

class OrderCompletedInitial extends OrderCompletedState {}

class OrderCompletedLoading extends OrderCompletedState {}

class OrderCompletedLoaded extends OrderCompletedState {
  final List<OrdergetuserModel> orders;

  const OrderCompletedLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderCompletedError extends OrderCompletedState {
  final String message;

  const OrderCompletedError(this.message);

  @override
  List<Object> get props => [message];
}
