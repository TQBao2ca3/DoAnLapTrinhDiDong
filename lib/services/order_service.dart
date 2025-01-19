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
      // Chuyển đổi payment_method sang dạng số
      int paymentMethodValue =
          paymentMethod == "Thanh toán khi nhận hàng" ? 0 : 1;

      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/orders/create'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'shipping_address': shippingAddress,
          'payment_method': paymentMethodValue, // Gửi giá trị số
          'order_details': orderDetails
              .map((detail) => {
                    'product_detail_id': detail['product_detail_id'],
                    'quantity': detail['quantity'],
                    'price': detail['price'],
                    'storage': detail['storage'],
                    'color': detail['colors'],
                  })
              .toList(),
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

  Future<void> updateOrderStatus(int orderId, int status) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiService.baseUrl}/orders/update-status/$orderId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'status': status,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update order status');
      }
    } catch (e) {
      throw Exception('Error updating order status: $e');
    }
  }
}
