class Invoice {
  final int id;
  final DateTime createdAt;
  final double totalPrice;
  final String paymentMethod;

  Invoice({
    required this.id,
    required this.createdAt,
    required this.totalPrice,
    required this.paymentMethod,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      totalPrice:
          double.parse(json['order_id']['total_price'].toString()).toDouble(),
      paymentMethod: json['order_id']['payment_method'],
    );
  }
}
