import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_get_user/order_event.dart';
import 'package:frontend_appflowershop/bloc/order/order_pending/order_pending_event.dart';
import 'package:frontend_appflowershop/bloc/order/order_pending/order_pending_state.dart';
import 'package:frontend_appflowershop/data/services/Order/api_order.dart';

class OrderPendingBloc extends Bloc<OrderPendingEvent, OrderPendingState> {
  final ApiOrderService apiService;
  OrderPendingBloc(this.apiService) : super(OrderPendingInitial()) {
    on<FetchPendingOrders>((event, emit) async {
      emit(OrderPendingLoading());
      try {
        final order = await apiService.getOrdersPending();
        emit(OrderPendingLoaded(order));
      } catch (e) {
        emit(OrderPendingError(e.toString()));
      }
    });
 
  }
}
