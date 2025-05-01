import 'dart:convert';
import 'dart:developer' as developer;
import 'package:frontend_appflowershop/data/models/invoice.dart';
import 'package:frontend_appflowershop/utils/constants.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';
import 'package:http/http.dart' as http;

class ApiInvoice {
  Future<List<Invoice>> getAllInvoices() async {
    developer.log('[ApiInvoice] Starting to fetch all invoices');
    try {
      final token = await PreferenceService.getToken();
      if (token == null) {
        developer.log('[ApiInvoice] Error: Token not found');
        throw Exception('Token not found');
      }
      developer.log('[ApiInvoice] Token retrieved: $token');

      final uri = Uri.parse('${Constants.baseUrl}/invoices');
      developer.log('[ApiInvoice] Sending GET request to: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      developer
          .log('[ApiInvoice] Response status code: ${response.statusCode}');
      developer.log('[ApiInvoice] Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 200) {
          final List<dynamic> invoiceData = jsonResponse['data'];
          final invoices =
              invoiceData.map((json) => Invoice.fromJson(json)).toList();
          developer.log(
              '[ApiInvoice] Invoices fetched successfully: ${invoices.length} invoices');
          return invoices;
        } else {
          final errorMessage = jsonResponse['message'] ?? 'Unknown error';
          developer.log('[ApiInvoice] API returned error: $errorMessage');
          throw Exception('API returned error: $errorMessage');
        }
      } else {
        developer.log(
            '[ApiInvoice] Failed to load invoices: ${response.statusCode} - ${response.reasonPhrase}');
        throw Exception(
            'Failed to load invoices: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      developer.log('[ApiInvoice] Error fetching invoices: $e');
      rethrow;
    }
  }
}
