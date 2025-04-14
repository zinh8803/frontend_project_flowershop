import 'package:bloc/bloc.dart';
import 'package:frontend_appflowershop/bloc/product/product_list_discount/product_list_discount_event.dart';
import 'package:frontend_appflowershop/bloc/product/product_list_discount/product_list_discount_state.dart';
import 'package:frontend_appflowershop/data/services/Product/api_product.dart';

class ProductListDiscountBloc
    extends Bloc<ProductListDiscountEvent, ProductListDiscountState> {
  final ApiService_product apiService;
  ProductListDiscountBloc(this.apiService)
      : super(ProductListDiscountInitial()) {
    on<ProductListDiscountEvent>((event, emit) async {
      emit(ProductListDiscountLoading());
      try {
        final products = await apiService.getProductsdiscount();
        if (products.isEmpty) {
          emit(ProductListDiscountNoData());
        } else {
          emit(ProductListDiscountLoaded(products));
        }
      } catch (e) {
        emit(ProductListDiscountError(e.toString()));
      }
    });
  }
}
