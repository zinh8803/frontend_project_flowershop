import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend_appflowershop/data/models/cart_item.dart';
import 'package:frontend_appflowershop/data/models/order.dart';
import 'package:frontend_appflowershop/utils/constants.dart';

class ApiOrderService {
  Future<OrderModel> placeOrder({
    required int userId,
    required String name,
    String? discount_id,
    required String email,
    required String phoneNumber,
    required String address,
    required String paymentMethod,
    required List<CartItem> cartItems,
  }) async {
    const url = '${Constants.baseUrl}/Order';


    final productsList = cartItems
        .asMap()
        .map((index, item) => MapEntry(index, {
              'product_id':
                  item.product.id, 
              'quantity': item.quantity,
            }))
        .values
        .toList();

    final body = jsonEncode({
      'user_id': userId,
      'discount_id': "",
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'payment_method': paymentMethod,
      'products': productsList,
    });

    print('Request body: $body');

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print('Response: ${response.body}');
      return OrderModel.fromJson(json['data']);
    } else {
      print('Error response: ${response.body}');
      throw Exception('Failed to place order: ${response.body}');
    }
  }
}
