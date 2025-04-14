import 'package:frontend_appflowershop/data/models/cart_item.dart';
import 'package:frontend_appflowershop/data/models/product.dart';

class CartService {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(ProductModel product) {
    final existingItem = _cartItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product),
    );

    if (_cartItems.contains(existingItem)) {
      existingItem.increaseQuantity();
    } else {
      _cartItems.add(existingItem);
    }
  }

  void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
  }

  void clearCart() {
    _cartItems.clear();
  }

  void increaseQuantity(int productId) {
    final item = _cartItems.firstWhere((item) => item.product.id == productId);
    item.increaseQuantity();
  }

  void decreaseQuantity(int productId) {
    final item = _cartItems.firstWhere((item) => item.product.id == productId);
    if (item.quantity > 1) {
      item.decreaseQuantity();
    } else {
      removeFromCart(productId);
    }
  }

  int get totalItems {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return _cartItems.fold(
        0, (sum, item) => sum + (item.product.finalPrice * item.quantity));
  }
}
