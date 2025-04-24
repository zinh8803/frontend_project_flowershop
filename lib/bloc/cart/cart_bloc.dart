import 'package:bloc/bloc.dart';
import 'package:frontend_appflowershop/bloc/cart/cart_event.dart';
import 'package:frontend_appflowershop/bloc/cart/cart_state.dart';
import 'package:frontend_appflowershop/data/services/cart/cart_service.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService cartService;

  CartBloc(this.cartService) : super(CartInitial()) {
    on<LoadCartEvent>((event, emit) {
      emit(CartLoading());
      try {
        final cartItems = cartService.cartItems;
        final totalItems = cartService.totalItems;
        final totalPrice = cartService.totalPrice;
        emit(CartLoaded(
          cartItems: cartItems,
          totalItems: totalItems,
          totalPrice: totalPrice,
        ));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });

    on<AddToCartEvent>((event, emit) {
      cartService.addToCart(
        event.product,
        size: event.size,
        colors: event.colors,
        quantity: event.quantity,
      );
      emit(CartLoaded(
        cartItems: cartService.cartItems,
        totalItems: cartService.totalItems,
        totalPrice: cartService.totalPrice,
      ));
    });

    on<RemoveFromCartEvent>((event, emit) {
      cartService.removeFromCart(
        event.productId,
        size: event.size,
        colors: event.colors,
      );
      emit(CartLoaded(
        cartItems: cartService.cartItems,
        totalItems: cartService.totalItems,
        totalPrice: cartService.totalPrice,
      ));
    });

    on<IncreaseQuantityEvent>((event, emit) {
      cartService.increaseQuantity(
        event.productId,
        size: event.size,
        colors: event.colors,
      );
      emit(CartLoaded(
        cartItems: cartService.cartItems,
        totalItems: cartService.totalItems,
        totalPrice: cartService.totalPrice,
      ));
    });

    on<DecreaseQuantityEvent>((event, emit) {
      cartService.decreaseQuantity(
        event.productId,
        size: event.size,
        colors: event.colors,
      );
      emit(CartLoaded(
        cartItems: cartService.cartItems,
        totalItems: cartService.totalItems,
        totalPrice: cartService.totalPrice,
      ));
    });

    on<ClearCartEvent>((event, emit) {
      cartService.clearCart();
      emit(CartLoaded(
        cartItems: cartService.cartItems,
        totalItems: cartService.totalItems,
        totalPrice: cartService.totalPrice,
      ));
    });
    on<ClearCartEventall>((event, emit) {
      print('ClearCartEvent received');
      try {
        cartService.clearCart();
        emit(CartLoaded(
          cartItems: cartService.cartItems,
          totalItems: cartService.totalItems,
          totalPrice: cartService.totalPrice,
        ));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });
  }
}
