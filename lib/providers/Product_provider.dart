import 'package:flutter/material.dart';
import 'package:phoneshop/models/Product.dart';
import 'package:phoneshop/services/Product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;

  List<Product> get products =>
      _selectedBrand.isEmpty ? _products : _filteredProducts;
  bool get isLoading => _isLoading;

  String _selectedBrand = '';
  // Thêm getter cho selectedBrand
  String get selectedBrand => _selectedBrand;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _productService.getProductList();
    } catch (error) {
      //handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByBrand(String brand) {
    _selectedBrand = brand.toLowerCase();
    _filteredProducts = _products
        .where((product) => product.name.toLowerCase().contains(_selectedBrand))
        .toList();
    notifyListeners();
  }

  void resetFilter() {
    _selectedBrand = '';
    _filteredProducts = [];
    notifyListeners();
  }
}
