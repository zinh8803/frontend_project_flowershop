import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_processing/order_processing_event.dart';
import 'package:frontend_appflowershop/bloc/order/order_processing/order_processing_state.dart';

import 'package:frontend_appflowershop/data/services/Order/api_order.dart';

class OrderProcessingBloc
    extends Bloc<OrderProcessingEvent, OrderProcessingState> {
  final ApiOrderService apiService;
  OrderProcessingBloc(this.apiService) : super(OrderProcessingInitial()) {
    on<FetchProcessingOrders>((event, emit) async {
      emit(OrderProcessingLoading());
      try {
        final order = await apiService.getOrdersProcessing();
        emit(OrderProcessingLoaded(order));
      } catch (e) {
        emit(OrderProcessingError(e.toString()));
      }
    });
  }
}
