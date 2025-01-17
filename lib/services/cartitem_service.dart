import 'dart:convert';

import 'package:phoneshop/models/CartItem.dart';
import 'package:phoneshop/services/Api_service.dart';

class CartItemService {
  Future<List<CartItem>> getCartByID(int cart_id) async {
    print('CartItemService - Starting getCartByID with cart_id: $cart_id');
    try {
      final response =
          await ApiService.getRequest('cart/getCartItemList/$cart_id');
      print('CartItemService - API Response status: ${response.statusCode}');
      print('CartItemService - API Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('CartItemService - Decoded data: $data');
        if (data['success']) {
          final List<CartItem> cartItems =
              (data['data'] as List).map((cartJson) {
            print('Parsing cart item: $cartJson');
            try {
              return CartItem.fromJson(cartJson);
            } catch (e) {
              print('Error parsing individual cart item: $e');
              rethrow;
            }
          }).toList();
          print(
              'CartItemService - Successfully parsed ${cartItems.length} items');
          return cartItems;
        } else {
          throw Exception('Failed to load cart items: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load cart items: ${response.statusCode}');
      }
    } catch (e) {
      print('CartItemService - Error: $e');
      throw e;
    }
  }
}
