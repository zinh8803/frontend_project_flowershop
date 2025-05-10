class DiscountCheckRequest {
  final int id;
  final String code;
  final double orderTotal;

  DiscountCheckRequest(
      {required this.id, required this.code, required this.orderTotal});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'order_total': orderTotal,
    };
  }
}

class DiscountCheckResponse {
  final String status;
  final String message;
  final DiscountData? data;

  DiscountCheckResponse(
      {required this.status, required this.message, this.data});

  factory DiscountCheckResponse.fromJson(Map<String, dynamic> json) {
    return DiscountCheckResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? DiscountData.fromJson(json['data']) : null,
    );
  }
}

class DiscountData {
  final int id;
  final String type;
  final double value;

  DiscountData({required this.id, required this.type, required this.value});

  factory DiscountData.fromJson(Map<String, dynamic> json) {
    return DiscountData(
      id: json['id'],
      type: json['type'],
      value: double.parse(json['value'].toString()),
    );
  }
}
