import 'dart:convert';

import 'package:frontend_appflowershop/data/models/discount_check_model.dart';
import 'package:frontend_appflowershop/utils/constants.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';
import 'package:http/http.dart' as http;

class DiscountService {
  Future<DiscountCheckResponse> checkDiscount(
      String code, double orderTotal) async {
    try {
      final token = await PreferenceService.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final uri = Uri.parse('${Constants.baseUrl}/discounts/check');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final body = jsonEncode({
        'code': code,
        'order_total': orderTotal,
      });

      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return DiscountCheckResponse.fromJson(decodedResponse);
      } else {
        print('Error Response: ${response.body}');
        throw Exception(
            'Failed to check discount: ${decodedResponse['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to connect to server: $e');
    }
  }
}
