import 'package:flutter/material.dart';
import 'package:phoneshop/models/Product_detail_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:phoneshop/services/product_detail_service.dart';

class ProductDetailProvider with ChangeNotifier {
  final ProductDetailService _productDetailService = ProductDetailService();
  Product_Detail? _productDetail;
  bool _isLoading = false;

  Product_Detail? get productDetail => _productDetail;
  bool get isLoading => _isLoading;

  Future<void> loadProductDetail(int productID) async {
    _isLoading = true;
    notifyListeners();
    try {
      print('product id: $productID');
      _productDetail = await _productDetailService.getDetail(productID);
    } catch (error) {
      //handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    // final response =
    //     await http.get(Uri.parse('http://192.168.1.6:3000/api/productdetail'));
    // if (response.statusCode == 200) {
    //   final List<dynamic> data = json.decode(response.body);
    //   _productDetail =
    //       data.map((item) => Product_Detail.fromJson(item)).toList();
    //   notifyListeners();
    // } else {
    //   throw Exception('Failed to load Product_Detail');
    // }
  }
}
