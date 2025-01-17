// order_service.dart
import 'dart:convert';

import 'package:phoneshop/models/CartItem.dart';
import 'package:http/http.dart' as http;

class OrderService {
  static Future<bool> createOrder({
    required int userId,
    required String shippingAddress,
    required String paymentMethod,
    required List<CartItem> cartItems,
  }) async {
    try {
      final url = Uri.parse('http://192.168.250.252:3000/api/orders/create');

      // Chuẩn bị dữ liệu để gửi lên server
      // final orderData = {
      //   'user_id': userId,
      //   'shipping_address': shippingAddress,
      //   'payment_method': paymentMethod,
      //   'order_details': cartItems
      //       .map((item) => {
      //             'product_detail_id': item.product
      //                 .id, // hoặc item.productDetailId tùy cấu trúc của bạn
      //             'quantity': item.stock_quantity,
      //             'price':
      //                 item.price[0], // hoặc item.selectedPrice tùy cấu trúc
      //             'storage': item.storage[0], // hoặc item.selectedStorage
      //             'color': item.colors[0], // hoặc item.selectedColor
      //           })
      //       .toList(),
      // };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        //body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Order created with ID: ${responseData['orderId']}');
        return true;
      }
      return false;
    } catch (e) {
      print('Error creating order: $e');
      return false;
    }
  }
}
