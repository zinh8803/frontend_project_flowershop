import 'package:frontend_appflowershop/data/models/cart_item.dart';
import 'package:frontend_appflowershop/data/models/product.dart';

class CartService {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(ProductModel product) {
    // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
    final existingItem = _cartItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product),
    );

    if (_cartItems.contains(existingItem)) {
      // Nếu sản phẩm đã có, tăng số lượng
      existingItem.increaseQuantity();
    } else {
      // Nếu sản phẩm chưa có, thêm mới vào giỏ hàng
      _cartItems.add(existingItem);
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng (nếu cần sau này)
  void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
  }

  // Xóa toàn bộ giỏ hàng (nếu cần sau này)
  void clearCart() {
    _cartItems.clear();
  }

  // Tính tổng số lượng sản phẩm trong giỏ hàng
  int get totalItems {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Tính tổng giá tiền
  double get totalPrice {
    return _cartItems.fold(
        0, (sum, item) => sum + (item.product.finalPrice * item.quantity));
  }
}
