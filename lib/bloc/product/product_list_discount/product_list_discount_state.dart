import 'package:equatable/equatable.dart';
import '../../../data/models/product.dart';

abstract class ProductListDiscountState extends Equatable {
  @override
  List<Object?> get props => [];
}
class ProductListDiscountInitial extends ProductListDiscountState {}
class ProductListDiscountLoading extends ProductListDiscountState {}
class ProductListDiscountLoaded extends ProductListDiscountState {
  final List<ProductModel> products;

  ProductListDiscountLoaded(this.products);

  @override
  List<Object?> get props => [products];
}
class ProductListDiscountError extends ProductListDiscountState {
  final String message;

  ProductListDiscountError(this.message);

  @override
  List<Object?> get props => [message];
}
class ProductListDiscountDetailLoading extends ProductListDiscountState {}
class ProductListDiscountDetailLoaded extends ProductListDiscountState {
  final ProductModel product;

  ProductListDiscountDetailLoaded(this.product);

  @override
  List<Object?> get props => [product];
}
class ProductListDiscountDetailError extends ProductListDiscountState {
  final String message;

  ProductListDiscountDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
class ProductListDiscountEmpty extends ProductListDiscountState {}
class ProductListDiscountNoInternet extends ProductListDiscountState {}
class ProductListDiscountNoData extends ProductListDiscountState {}
class ProductListDiscountNoMoreData extends ProductListDiscountState {}

class ProductListDiscountNoMoreDataLoading extends ProductListDiscountState {}
class ProductListDiscountNoMoreDataLoaded extends ProductListDiscountState {
  final List<ProductModel> products;

  ProductListDiscountNoMoreDataLoaded(this.products);

  @override
  List<Object?> get props => [products];
}
class ProductListDiscountNoMoreDataError extends ProductListDiscountState {
  final String message;

  ProductListDiscountNoMoreDataError(this.message);

  @override
  List<Object?> get props => [message];
}
    
