import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend_appflowershop/bloc/discount/discount_check_event.dart';
import 'package:frontend_appflowershop/bloc/discount/discount_check_state.dart';
import 'package:frontend_appflowershop/data/models/discount_check_model.dart';
import 'package:frontend_appflowershop/data/services/discount/api_discount.dart';


class DiscountCheckBloc extends Bloc<DiscountCheckEvent, DiscountCheckState> {
  final DiscountService _discountCheckService;

  DiscountCheckBloc({required DiscountService discountCheckService})
      : _discountCheckService = discountCheckService,
        super(DiscountCheckInitial()) {
    on<CheckDiscountCode>(_onCheckDiscountCode);
  }
  Future<void> _onCheckDiscountCode(
    CheckDiscountCode event,
    Emitter<DiscountCheckState> emit,
  ) async {
    emit(DiscountCheckLoading());
    try {
      final request = DiscountCheckRequest(
        id: event.id,
        code: event.discountCode,
        orderTotal: event.orderTotal,
      );
      final response = await _discountCheckService.checkDiscount(request.code, request.orderTotal);

      if (response.status == 'success' && response.data != null) {
        final discountData = response.data!;
        double discountedPrice = event.orderTotal;
        if (discountData.type == 'fixed') {
          discountedPrice -= discountData.value;
        } else if (discountData.type == 'percentage') {
          discountedPrice *= (1 - (discountData.value / 100));
        }
        emit(DiscountCheckSuccess(discountData: discountData, discountedPrice: discountedPrice));
      } else {
        emit(DiscountCheckError(message: response.message));
      }
    } catch (e) {
      emit(DiscountCheckError(message: 'Không thể kiểm tra mã giảm giá: $e'));
    }
  }
}