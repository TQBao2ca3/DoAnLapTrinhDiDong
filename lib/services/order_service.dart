import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:phoneshop/services/api_service.dart';

class OrderService {
  Future<Map<String, dynamic>> createOrder({
    required int userId,
    required String shippingAddress,
    required String paymentMethod,
    required List<Map<String, dynamic>> orderDetails,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/orders/create'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'shipping_address': shippingAddress,
          'payment_method': paymentMethod,
          'status_order': 'Pending',
          'status_payment': 'Unpaid',
          'order_details': orderDetails,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }
}
