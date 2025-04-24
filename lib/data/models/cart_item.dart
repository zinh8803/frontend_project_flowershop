import 'package:frontend_appflowershop/data/models/color.dart';
import 'package:frontend_appflowershop/data/models/product.dart';
import 'package:frontend_appflowershop/data/models/size.dart';

class CartItem {
  final ProductModel product;
  final SizeModel? size;
  final List<ColorModel> colors;
  int quantity;

  CartItem({
    required this.product,
    this.size,
    this.colors = const [],
    this.quantity = 1,
  });

  void increaseQuantity() {
    quantity++;
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }

  double get totalPrice {
    return product.finalPrice * quantity;
  }
}
