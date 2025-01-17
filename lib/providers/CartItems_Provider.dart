import 'package:flutter/foundation.dart';
import 'package:phoneshop/models/CartItem.dart';
import 'package:phoneshop/models/Product.dart';
import 'package:phoneshop/services/cartitem_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartProvider with ChangeNotifier {
  final CartItemService _cartItemService = CartItemService();

  List<CartItem> _items = [];
  bool _isLoading = false;

  //thêm getter
  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  int _cart_id = 0;

  int get cart_id => _cart_id;

  void setCartId(int cart_id) {
    _cart_id = cart_id;
    notifyListeners();
  }

  void clearCartId() {
    _cart_id = 0;
    notifyListeners();
  }

  int getItemCount() {
    return _items.length;
  }

  //tải danh sách giỏ hàng
  Future<void> loadCartItems(int cart_id) async {
    print('loadCartItems called with cart_id: $cart_id'); // Thêm log
    _isLoading = true;
    notifyListeners();

    try {
      print('Attempting to load cart items'); // Thêm log
      _items = await _cartItemService.getCartByID(cart_id);
      print('Cart items loaded: ${_items.length} items'); // Thêm log
    } catch (e) {
      print('Error loading cart items: $e'); // Thêm detailed error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(Product product) async {
    try {
      final url = Uri.parse('http://192.168.250.252:3000/api/cart/addToCart');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cart_id': _cart_id,
          'product_detail_id': product.product_id,
          'quantity': 1
        }),
      );

      if (response.statusCode == 200) {
        int index = _items.indexWhere((item) =>
            item.description == product.name &&
            item.storage == product.storage[0] &&
            item.colors == product.colors[0]);

        if (index != -1) {
          _items[index].quantity += 1;
        } else {
          _items.add(CartItem(
              cart_id: _cart_id,
              cart_item_id: 0,
              product_detail_id: product.product_id,
              description: product.name,
              price: product.price[0],
              quantity: 1,
              image_url: product.image_url,
              colors: product.colors[0],
              storage: product.storage[0],
              storeName: 'Phone Shop'));
        }
        await loadCartItems(_cart_id); // Tải lại danh sách giỏ hàng
        notifyListeners();
      } else {
        print('Error adding to cart: ${response.body}');
        throw Exception('Failed to add item to cart');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<void> remove(CartItem product) async {
    try {
      final url = Uri.parse('http://192.168.1.4:3000/api/cart/deleteCartItem');
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cart_id': _cart_id,
          'product_detail_id': product.product_detail_id,
        }),
      );

      if (response.statusCode == 200) {
        _items.removeWhere((item) =>
            item.product_detail_id == product.product_detail_id &&
            item.cart_id == product.cart_id);
        notifyListeners();
      } else {
        print('Error removing item: ${response.body}');
        throw Exception('Failed to remove item from cart');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<void> updateQuantity(CartItem product, int quantity) async {
    try {
      final url = Uri.parse('http://192.168.1.4:3000/api/cart/updateQuantity');

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cart_id': _cart_id,
          'product_detail_id':
              product.product_detail_id, // Sử dụng product_detail_id mới
          'quantity': quantity
        }),
      );

      if (response.statusCode == 200) {
        int index = _items.indexWhere((item) =>
            item.description == product.description &&
            item.storage == product.storage &&
            item.colors == product.colors);

        if (index != -1) {
          _items[index].quantity = quantity;
          notifyListeners();
        }
      } else {
        print('Error updating quantity: ${response.body}');
        throw Exception('Failed to update quantity');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  double getTotalPrice() {
    return _items.fold(
        0, (total, current) => total + current.price * current.quantity);
  }
}
