import 'package:flutter/foundation.dart';
import 'package:phoneshop/models/CartItem.dart';
import 'package:phoneshop/models/Product.dart';
import 'package:phoneshop/services/cartitem_service.dart';

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

  void add(Product product) {
    int index = _items.indexWhere((item) =>
        item.description == product.name &&
        item.storage == product.storage[0] &&
        item.colors == product.colors[0]);

    if (index != -1) {
      // Nếu đã có, tăng số lượng
      _items[index].quantity += 1;
    } else {
      // Nếu chưa có, thêm mới
      _items.add(CartItem(
          cart_id: product.product_id,
          cart_item_id: 0,
          description: product.name,
          price: product.price[0],
          quantity: 1,
          image_url: product.image_url,
          colors: product.colors[0],
          storage: product.storage[0],
          storeName: 'Phone Shop'));
    }
    notifyListeners();
  }

  void remove(CartItem product) {
    // Cập nhật điều kiện xóa để đảm bảo xóa đúng sản phẩm
    _items.removeWhere((item) =>
        item.description == product.description &&
        item.storage[0] == product.storage[0] &&
        item.colors[0] == product.colors[0]);
    notifyListeners();
  }

  void updateQuantity(CartItem product, int quantity) {
    // Cập nhật số lượng cho đúng sản phẩm dựa trên tất cả thuộc tính
    int index = _items.indexWhere((item) =>
        item.description == product.description &&
        item.storage[0] == product.storage[0] &&
        item.colors[0] == product.colors[0]);

    if (index != -1) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  double getTotalPrice() {
    return _items.fold(
        0, (total, current) => total + current.price * current.quantity);
  }
}
