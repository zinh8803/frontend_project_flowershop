import 'package:frontend_appflowershop/data/models/cart_item.dart';

abstract class CheckoutEvent {}

class LoadCheckoutDataEvent extends CheckoutEvent {}

class PlaceOrderEvent extends CheckoutEvent {
  final int userId;
  final String name;
  final String? discount_id;
  final String email;
  final String phoneNumber;
  final String address;
  final String paymentMethod;
  final List<CartItem> cartItems;

  PlaceOrderEvent({
    required this.userId,
    required this.name,
    this.discount_id,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.paymentMethod,
    required this.cartItems,
  });
}
