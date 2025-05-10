abstract class ProductDetailEvent {}

class FetchProductDetailEvent extends ProductDetailEvent {
  final int productId;

  FetchProductDetailEvent(this.productId);
}
class ResetProductDetailEvent extends ProductDetailEvent {
  @override
  List<Object?> get props => [];
}