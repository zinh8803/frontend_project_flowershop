import 'package:bloc/bloc.dart';
import 'package:frontend_appflowershop/bloc/checkout/checkout_event.dart';
import 'package:frontend_appflowershop/bloc/checkout/checkout_state.dart';
import 'package:frontend_appflowershop/data/services/Order/api_order.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final ApiOrderService apiOrderService;

  CheckoutBloc(this.apiOrderService) : super(CheckoutInitial()) {
    on<LoadCheckoutDataEvent>((event, emit) {
      emit(CheckoutLoading());
    });

    on<PlaceOrderEvent>((event, emit) async {
      emit(CheckoutLoading());
      try {
        final order = await apiOrderService.placeOrder(
          userId: event.userId,
          discount_id: event.discount_id,
          name: event.name,
          email: event.email,
          phoneNumber: event.phoneNumber,
          address: event.address,
          paymentMethod: event.paymentMethod,
          cartItems: event.cartItems,
        );
        emit(CheckoutSuccess(order));
      } catch (e) {
        emit(CheckoutError(e.toString()));
      }
    });
  }
}
