import 'package:flutter/foundation.dart';
import 'package:phoneshop/models/Product.dart';

class CartProvider with ChangeNotifier {
  static final CartProvider _cartProvider = CartProvider._internal();
  CartProvider._internal();

  factory CartProvider() => _cartProvider;

  final List<Product> _items = [];

  List<Product> get items => _items;

  int getItemCount() {
    return _items.length;
  }

  void add(Product product) {
    // Thay đổi điều kiện kiểm tra để bao gồm cả storage và colors
    int index = _items.indexWhere((item) =>
            item.name == product.name &&
            item.storage[0] == product.storage[0] && // So sánh storage
            item.colors[0] == product.colors[0] // So sánh màu sắc
        );

    if (index != -1) {
      // Nếu sản phẩm đã tồn tại (cùng tên, storage và màu), tăng số lượng
      _items[index].stock_quantity += 1;
    } else {
      // Nếu là sản phẩm mới hoặc khác cấu hình, thêm mới vào giỏ hàng
      _items.add(product);
    }
    notifyListeners();
  }

  void remove(Product product) {
    // Cập nhật điều kiện xóa để đảm bảo xóa đúng sản phẩm
    _items.removeWhere((item) =>
        item.name == product.name &&
        item.storage[0] == product.storage[0] &&
        item.colors[0] == product.colors[0]);
    notifyListeners();
  }

  void updateQuantity(Product product, int quantity) {
    // Cập nhật số lượng cho đúng sản phẩm dựa trên tất cả thuộc tính
    int index = _items.indexWhere((item) =>
        item.name == product.name &&
        item.storage[0] == product.storage[0] &&
        item.colors[0] == product.colors[0]);

    if (index != -1) {
      _items[index].stock_quantity = quantity;
      notifyListeners();
    }
  }

  double getTotalPrice() {
    return _items.fold(0,
        (total, current) => total + current.price[0] * current.stock_quantity);
  }
}
