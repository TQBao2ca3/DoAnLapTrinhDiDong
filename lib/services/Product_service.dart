// Product_service.dart
import 'dart:convert';
import 'package:phoneshop/models/Product.dart';
import 'package:phoneshop/services/Api_service.dart';

class ProductService {
  Future<List<Product>> getProductByID(int productID) async {
    try {
      final response =
          await ApiService.getRequest('product/getProductList/$productID');
      print('API Response: ${response.body}'); // Thêm log

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded data: $data'); // Thêm log
        if (data['success']) {
          final products = (data['data'] as List)
              .map((productJson) => Product.fromJson(productJson))
              .toList();
          print('Parsed products: $products'); // Thêm log
          return products;
        } else {
          throw Exception('Failed to load products: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getProduct: $e'); // Thêm log
      throw e;
    }
  }

  Future<List<Product>> getProductList() async {
    try {
      final response = await ApiService.getRequest('product/getProductList');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Success status: ${data['success']}');
        if (data['success']) {
          final products = (data['data'] as List)
              .map((productJson) => Product.fromJson(productJson))
              .toList();
          return products;
        } else {
          throw Exception('Failed to load products: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw e;
    }
  }
}
