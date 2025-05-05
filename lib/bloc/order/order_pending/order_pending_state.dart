import 'package:equatable/equatable.dart';
import 'package:frontend_appflowershop/data/models/ordergetuser.dart';

abstract class OrderPendingState extends Equatable {
  const OrderPendingState();

  @override
  List<Object> get props => [];
}

class OrderPendingInitial extends OrderPendingState {}

class OrderPendingLoading extends OrderPendingState {}

class OrderPendingLoaded extends OrderPendingState {
  final List<OrdergetuserModel> orders;

  const OrderPendingLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}



class OrderPendingError extends OrderPendingState {
  final String message;

  const OrderPendingError(this.message);

  @override
  List<Object> get props => [message];
}
