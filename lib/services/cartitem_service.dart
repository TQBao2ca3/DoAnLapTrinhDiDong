// cartitem_service.dart
import 'dart:convert';
import 'package:phoneshop/models/CartItem.dart';
import 'package:phoneshop/services/Api_service.dart';

class CartItemService {
  Future<List<CartItem>> getCartByUserId(int userId) async {
    print('CartItemService - Starting getCartByUserId with userId: $userId');
    try {
      final response =
          await ApiService.getRequest('cart/getCartItemList/$userId');
      print('CartItemService - API Response status: ${response.statusCode}');
      print('CartItemService - API Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return (data['data'] as List)
              .map((json) => CartItem.fromJson(json))
              .toList();
        }
      }
      throw Exception('Failed to load cart items');
    } catch (e) {
      print('CartItemService - Error: $e');
      throw e;
    }
  }
}
