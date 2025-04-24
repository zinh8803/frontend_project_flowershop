import 'package:frontend_appflowershop/data/models/cart_item.dart';
import 'package:frontend_appflowershop/data/models/color.dart';
import 'package:frontend_appflowershop/data/models/product.dart';
import 'package:frontend_appflowershop/data/models/size.dart';

class CartService {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(
    ProductModel product, {
    SizeModel? size,
    List<ColorModel>? colors,
    int quantity = 1,
  }) {
    // Kiểm tra xem sản phẩm với cùng size và colors có trong giỏ hàng chưa
    final existingItem = _cartItems.firstWhere(
      (item) =>
          item.product.id == product.id &&
          item.size?.id == size?.id &&
          _areColorsEqual(item.colors, colors ?? []),
      orElse: () => CartItem(
        product: product,
        size: size,
        colors: colors ?? [],
        quantity: 0, // Sẽ được cập nhật sau
      ),
    );

    if (_cartItems.contains(existingItem)) {
      existingItem.quantity += quantity;
    } else {
      existingItem.quantity = quantity;
      _cartItems.add(existingItem);
    }
  }

  // So sánh hai danh sách colors
  bool _areColorsEqual(List<ColorModel> colors1, List<ColorModel> colors2) {
    if (colors1.length != colors2.length) return false;
    final ids1 = colors1.map((c) => c.id).toSet();
    final ids2 = colors2.map((c) => c.id).toSet();
    return ids1.difference(ids2).isEmpty;
  }

  void removeFromCart(int productId,
      {SizeModel? size, List<ColorModel>? colors}) {
    _cartItems.removeWhere(
      (item) =>
          item.product.id == productId &&
          item.size?.id == size?.id &&
          _areColorsEqual(item.colors, colors ?? []),
    );
  }

  void clearCart() {
    _cartItems.clear();
  }

  void increaseQuantity(int productId,
      {SizeModel? size, List<ColorModel>? colors}) {
    final item = _cartItems.firstWhere(
      (item) =>
          item.product.id == productId &&
          item.size?.id == size?.id &&
          _areColorsEqual(item.colors, colors ?? []),
    );
    item.increaseQuantity();
  }

  void decreaseQuantity(int productId,
      {SizeModel? size, List<ColorModel>? colors}) {
    final item = _cartItems.firstWhere(
      (item) =>
          item.product.id == productId &&
          item.size?.id == size?.id &&
          _areColorsEqual(item.colors, colors ?? []),
    );
    if (item.quantity > 1) {
      item.decreaseQuantity();
    } else {
      removeFromCart(productId, size: size, colors: colors);
    }
  }

  int get totalItems {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }
}
