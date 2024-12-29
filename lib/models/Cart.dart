import 'package:flutter/foundation.dart';
import 'Product.dart';
class Cart with ChangeNotifier {
  static final Cart _instance = Cart._internal();
  Cart._internal();

  factory Cart() => _instance;

  final List<Product> _items = [];

  List<Product> get items => _items;
  int getItemCount() {
    return _items.length;
  }
  void add(Product product) {
    int index = _items.indexWhere((item) => item.title == product.title);
    if (index != -1) {
      _items[index].quantity += 1;
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void remove(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  void updateQuantity(Product product, int quantity) {
    int index = _items.indexWhere((item) => item.title == product.title);
    if (index != -1) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  double getTotalPrice() {
    return _items.fold(0, (total, current) => total + current.price * current.quantity);
  }
}