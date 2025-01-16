// import 'package:flutter/material.dart';
// import 'package:phoneshop/models/Product_detail_model.dart';

// import 'package:phoneshop/services/product_detail_service.dart';

// class ProductDetailProvider with ChangeNotifier {
//   final ProductDetailService _productDetailService = ProductDetailService();
//   List<Product_Detail> _productDetails = [];
//   bool _isLoading = false;

//   List<Product_Detail> get productDetail => _productDetails;
//   bool get isLoading => _isLoading;

//   Future<void> loadProductDetail(int productID) async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       print('product id: $productID');
//       _productDetails = await _productDetailService.getDetail(productID);
//     } catch (error) {
//       //handle error
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   String getPriceForStorageAndColor(String storage, String color) {
//     final detail = _productDetails.firstWhere(
//         (detail) => detail.storage == storage && detail.colors == color,
//         orElse: () => _productDetails.first);
//     return detail.price;
//   }
// }
