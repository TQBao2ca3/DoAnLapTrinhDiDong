import 'package:flutter/foundation.dart';
import 'package:phoneshop/models/CartItem.dart';
import 'package:phoneshop/models/Product.dart';
import 'package:phoneshop/services/api_service.dart';
import 'package:phoneshop/services/cartitem_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartProvider with ChangeNotifier {
  final CartItemService _cartItemService = CartItemService();
  int? _userId;
  int _cartId = 0;
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

// Thêm setter cho userId
  Future<void> setUserId(int userId) async {
    _userId = userId;
    await loadCartItems();
    notifyListeners();
  }

  Future<void> initializeWithUserId(int userId) async {
    _userId = userId;

    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/cart/getOrCreateCart/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);
      if (data['success']) {
        _cart_id = data['cart_id'];
        print('Initialized cart_id: $_cart_id for userId: $userId');

        // Load cart items sau khi có cart_id
        await loadCartItems();
        notifyListeners();
      } else {
        print('Failed to get cart_id');
      }
    } catch (e) {
      print('Error initializing cart: $e');
    }
  }

  // Sửa lại loadCartItems để dùng userId
  Future<void> loadCartItems() async {
    if (_userId == null) {
      print('CartProvider - userId is null, cannot load items');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      print('CartProvider - Loading items for userId: $_userId');
      _items = await _cartItemService.getCartByUserId(_userId!);
      if (_items.isNotEmpty) {
        _cartId = _items.first.cart_id;
      }
    } catch (e) {
      print('Error loading cart items: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(
      Product product, String selectedColor, String selectedStorage) async {
    if (_cart_id == 0) {
      print('Error: cart_id not initialized');
      return;
    }
    try {
      // Lấy giá tương ứng với storage đã chọn
      int storageIndex = product.storage.indexOf(selectedStorage);
      if (storageIndex == -1) storageIndex = 0;
      int selectedPrice = product.price[storageIndex];

      final url = Uri.parse('${ApiService.baseUrl}/cart/addToCart');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cart_id': _cart_id,
          'product_detail_id': product.product_id,
          'quantity': 1,
          'color': selectedColor,
          'storage': selectedStorage,
          'price': selectedPrice
        }),
      );

      if (response.statusCode == 200) {
        await loadCartItems();
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
      final url = Uri.parse('${ApiService.baseUrl}/cart/deleteCartItem');
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cart_id': _cart_id,
          'product_detail_id': product.product_detail_id,
          'color': product.colors, // Thêm màu sắc
          'storage': product.storage // Thêm dung lượng
        }),
      );

      if (response.statusCode == 200) {
        _items.removeWhere((item) =>
                item.product_detail_id == product.product_detail_id &&
                item.cart_id == product.cart_id &&
                item.colors == product.colors && // Thêm điều kiện màu sắc
                item.storage == product.storage // Thêm điều kiện dung lượng
            );
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
      final url = Uri.parse('${ApiService.baseUrl}/cart/updateQuantity');

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

  // Hoặc nếu bạn muốn xóa trên server
  Future<void> clearCart() async {
    try {
      final url = Uri.parse('${ApiService.baseUrl}/cart/clear');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cart_id': _cartId,
        }),
      );

      if (response.statusCode == 200) {
        _items = [];
        notifyListeners();
      } else {
        throw Exception('Failed to clear cart');
      }
    } catch (e) {
      print('Error clearing cart: $e');
      throw e;
    }
  }
}
