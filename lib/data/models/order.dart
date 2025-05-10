class OrderModel {
  final int id;
  final int user_id;
  final double total_price;
  final String? status;
  final String? name;
  final String? address;
  final String? phone;
  final String? email;
  final String? created_at;
  final String? updated_at;
  final DiscountModel? discount;
  final String? payment_method;

  OrderModel({
    required this.id,
    required this.user_id,
    required this.total_price,
    this.status,
    this.name,
    this.address,
    this.phone,
    this.email,
    this.created_at,
    this.updated_at,
    this.discount,
    this.payment_method,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      user_id: json['user_id'] ?? 0,
      total_price: double.tryParse(json['total_price'].toString()) ?? 0.0,
      status: json['status'],
      name: json['name'],
      address: json['address'],
      phone: json['phone_number'],
      email: json['email'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      discount: json['discount'] is Map<String, dynamic>
          ? DiscountModel.fromJson(json['discount'])
          : null,
      payment_method: json['payment_method'] ?? 'pending',
    );
  }
}

class DiscountModel {
  final int id;
  final String code;
  final String type;
  final String value;

  DiscountModel({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'],
      code: json['code'],
      type: json['type'],
      value: json['value'],
    );
  }
}
