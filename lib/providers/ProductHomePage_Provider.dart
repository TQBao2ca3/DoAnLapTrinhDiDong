import 'package:flutter/material.dart';
import 'package:phoneshop/models/ProductHomePage.dart';
import 'package:phoneshop/services/ProductHomePage_service.dart';
import 'package:phoneshop/services/Product_service.dart';

class ProductHomePageProvider with ChangeNotifier {
  final ProductHomePageService _productService = ProductHomePageService();
  List<ProductHomePage> _productsHomepage = [];
  bool _isLoading = false;

  List<ProductHomePage> get productsHomePage => _productsHomepage;
  bool get isLoading => _isLoading;

  Future<void> loadProductsHomePage() async {
    _isLoading = true;
    notifyListeners();
    try {
      _productsHomepage = await _productService.getProductHomePage();
    } catch (e) {
      //handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
