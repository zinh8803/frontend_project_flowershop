// Model cho danh sách đơn hàng (giữ nguyên)
class OrdergetuserModel {
  final int id;
  final int userId;
  final double totalPrice;
  final String status;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String paymentMethod;
  final String createdAt;
  final String updatedAt;
  final String? discount;
  final List<OrderItemModel> orderItems;

  OrdergetuserModel({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.status,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.paymentMethod,
    required this.createdAt,
    required this.updatedAt,
    this.discount,
    required this.orderItems,
  });

  factory OrdergetuserModel.fromJson(Map<String, dynamic> json) {
    return OrdergetuserModel(
      id: json['id'],
      userId: json['user_id'],
      totalPrice: double.parse(json['total_price']),
      status: json['status'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      paymentMethod: json['payment_method'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      discount: json['discount'],
      orderItems: (json['order_items'] as List)
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
    );
  }
}

// Model cho chi tiết đơn hàng
class OrderDetailModel {
  final int id;
  final int userId;
  final double totalPrice;
  final String status;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String paymentMethod;
  final String createdAt;
  final String updatedAt;
  final String? discount;
  final List<OrderItemModel> orderItems;

  OrderDetailModel({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.status,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.paymentMethod,
    required this.createdAt,
    required this.updatedAt,
    this.discount,
    required this.orderItems,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id'],
      userId: json['user_id'],
      totalPrice: double.parse(json['total_price']),
      status: json['status'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      paymentMethod: json['payment_method'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      discount: json['discount'],
      orderItems: (json['order_items'] as List)
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
    );
  }
}

class OrderItemModel {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final double price;
  final int? sizeId;
  final List<dynamic>? colors;
  final ProductModel? product;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    this.sizeId,
    this.colors,
    this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: double.parse(json['price']),
      sizeId: json['size_id'],
      colors: (json['colors'] as List?)
          ?.map((colorMap) => colorMap['color_id'] as int?)
          .toList(),
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
    );
  }
}

class ProductModel {
  final int id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String imageUrl;
  final int categoryId;
  final String createdAt;
  final String updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price']),
      stock: json['stock'],
      imageUrl: json['image_url'],
      categoryId: json['category_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
