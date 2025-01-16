import 'package:flutter/material.dart';
import 'package:phoneshop/models/Product.dart';
import 'package:phoneshop/services/Product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    if (_isLoading) return; // Tránh gọi nhiều lần

    _isLoading = true;
    // Đợi frame tiếp theo trước khi notify
    Future.microtask(() => notifyListeners());

    try {
      _products = await _productService.getProductList();
    } catch (error) {
      //handle error
    } finally {
      _isLoading = false;
      // Đợi frame tiếp theo trước khi notify
      Future.microtask(() => notifyListeners());
    }
  }
}
