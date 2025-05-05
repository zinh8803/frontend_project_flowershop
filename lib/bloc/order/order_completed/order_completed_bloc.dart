import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_completed/order_completed_event.dart';
import 'package:frontend_appflowershop/bloc/order/order_completed/order_completed_state.dart';
import 'package:frontend_appflowershop/data/services/Order/api_order.dart';

class OrderCompletedBloc
    extends Bloc<OrderCompletedEvent, OrderCompletedState> {
  final ApiOrderService apiService;
  OrderCompletedBloc(this.apiService) : super(OrderCompletedInitial()) {
    on<FetchCompletedOrders>((event, emit) async {
      emit(OrderCompletedLoading());
      try {
        final order = await apiService.getOrdersCompleted();
        emit(OrderCompletedLoaded(order));
      } catch (e) {
        emit(OrderCompletedError(e.toString()));
      }
    });
  }
}
