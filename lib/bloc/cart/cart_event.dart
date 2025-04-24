import 'package:equatable/equatable.dart';
import 'package:frontend_appflowershop/data/models/color.dart';
import 'package:frontend_appflowershop/data/models/product.dart';
import 'package:frontend_appflowershop/data/models/size.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final ProductModel product;
  final SizeModel? size;
  final List<ColorModel>? colors;
  final int quantity;

  const AddToCartEvent({
    required this.product,
    this.size,
    this.colors,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [product, size, colors, quantity];
}

class RemoveFromCartEvent extends CartEvent {
  final int productId;
  final SizeModel? size;
  final List<ColorModel>? colors;

  const RemoveFromCartEvent({
    required this.productId,
    this.size,
    this.colors,
  });

  @override
  List<Object?> get props => [productId, size, colors];
}

class IncreaseQuantityEvent extends CartEvent {
  final int productId;
  final SizeModel? size;
  final List<ColorModel>? colors;

  const IncreaseQuantityEvent({
    required this.productId,
    this.size,
    this.colors,
  });

  @override
  List<Object?> get props => [productId, size, colors];
}

class DecreaseQuantityEvent extends CartEvent {
  final int productId;
  final SizeModel? size;
  final List<ColorModel>? colors;

  const DecreaseQuantityEvent({
    required this.productId,
    this.size,
    this.colors,
  });

  @override
  List<Object?> get props => [productId, size, colors];
}

class ClearCartEvent extends CartEvent {}

class ClearCartEventall extends CartEvent {}
