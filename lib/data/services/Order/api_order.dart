import 'dart:convert';
import 'package:frontend_appflowershop/data/models/employee.dart';
import 'package:frontend_appflowershop/data/models/ordergetuser.dart';
import 'package:frontend_appflowershop/data/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_appflowershop/data/models/cart_item.dart';
import 'package:frontend_appflowershop/data/models/order.dart';
import 'package:frontend_appflowershop/utils/constants.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';

class ApiOrderService {
  Future<OrderModel> placeOrder({
    required int userId,
    required String name,
    int? discount_id,
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
              'product_id': item.product.id,
              'quantity': item.quantity,
              "size_id": item.size?.id ?? 1,
              "color_ids": item.colors.map((color) => color.id).toList(),
            }))
        .values
        .toList();

    print('Products List Input: $productsList');

    final body = jsonEncode({
      'user_id': userId,
      'discount_id': discount_id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'payment_method': paymentMethod,
      'products': productsList,
    });

    print('Request body111: $body');

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

  Future<List<OrdergetuserModel>> getOrdersPending() async {
    final token = await PreferenceService.getToken();
    if (token == null) {
      throw Exception('Token not found. Please log in again.');
    }

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/Order-pending'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];
      return data.map((item) => OrdergetuserModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load orders: ${response.body}');
    }
  }

  Future<List<OrdergetuserModel>> getOrdersProcessing() async {
    final token = await PreferenceService.getToken();
    final employeeId = await getEmployeeId();
    if (token == null) {
      throw Exception('Token not found. Please log in again.');
    }

    final response = await http.get(
      Uri.parse(
          '${Constants.baseUrl}/Order-processing?employee_id=$employeeId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];
      return data.map((item) => OrdergetuserModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load orders: ${response.body}');
    }
  }

  Future<List<OrdergetuserModel>> getOrdersCompleted() async {
    final token = await PreferenceService.getToken();
    final employeeId = await getEmployeeId();
    if (token == null) {
      throw Exception('Token not found. Please log in again.');
    }

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/Order-completed?employee_id=$employeeId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];
      return data.map((item) => OrdergetuserModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load orders: ${response.body}');
    }
  }

  Future<dynamic> getEmployeeId() async {
    try {
      final token = await PreferenceService.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Fetching user profile from: ${Constants.baseUrl}/user/profile');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'];

        if (data['position'] != null) {
          final employeeId = data['id'] as int;
          return employeeId;
        } else {
          final user = UserModel.fromJson(data, token);
          print('Returning UserModel: $user');
          return user;
        }
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow;
    }
  }

  Future<void> updateOrderStatusPending(int orderId) async {
    final token = await PreferenceService.getToken();
    if (token == null) {
      throw Exception('Token not found. Please log in again.');
    }
    final employeeId = await getEmployeeId();
    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/Order/$orderId/status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'status': 'processing',
        'employee_id': employeeId,
      }),
    );

    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to update order status: ${response.body}');
    }
  }

  Future<void> updateOrderStatusCompleted(int orderId) async {
    final token = await PreferenceService.getToken();
    if (token == null) {
      throw Exception('Token not found. Please log in again.');
    }
    final employeeId = await getEmployeeId();
    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/Order/$orderId/status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'status': 'completed',
        'employee_id': employeeId,
      }),
    );

    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to update order status: ${response.body}');
    }
  }

  Future<List<OrdergetuserModel>> getUserOrders() async {
    final token = await PreferenceService.getToken();
    if (token == null) {
      throw Exception('Token not found. Please log in again.');
    }

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/Order/User'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];
      return data.map((item) => OrdergetuserModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load user orders: ${response.body}');
    }
  }

  Future<OrdergetuserModel> getOrderDetail(int orderId) async {
    final token = await PreferenceService.getToken();
    if (token == null) {
      throw Exception('Token not found. Please log in again.');
    }

    final response = await http
        .get(Uri.parse('${Constants.baseUrl}/Order/detail=$orderId'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return OrdergetuserModel.fromJson(json['data']);
    } else {
      throw Exception('Failed to load order detail: ${response.body}');
    }
  }
}
