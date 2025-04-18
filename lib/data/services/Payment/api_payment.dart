import 'dart:convert';

import 'package:frontend_appflowershop/data/models/vnpay.dart';
import 'package:frontend_appflowershop/utils/constants.dart';
import 'package:http/http.dart' as http;

class ApiService_payment {
  Future<VNPay> getPaymentUrl(String orderId, double amount) async {
    try {
      print(
          'Calling API /payment with orderId: $orderId, amount: $amount'); // Log để kiểm tra
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'order_id': orderId, 'amount': amount.toString()}),
      );
      print(
          'API /payment response status: ${response.statusCode}'); // Log status
      print('API /payment response body: ${response.body}'); // Log body

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return VNPay.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to load payment url: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in getPaymentUrl: $e'); // Log lỗi
      throw Exception('Failed to load payment url: $e');
    }
  }
}
