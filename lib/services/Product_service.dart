import 'dart:convert';

import 'package:phoneshop/models/Product.dart';
import 'package:phoneshop/services/Api_service.dart';

class ProductService {
  //lấy danh sách sản phẩm
  Future<List<Product>> getProductByID(int productID) async {
    try {
      final response =
          await ApiService.getRequest('product/getProductList/$productID');
      print('API Response: ${response.body}'); // Thêm log

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded data: $data'); // Thêm log
        print(
            'Data type of product_id: ${data['data'][0]['product_id'].runtimeType}');
        print('Data type of price: ${data['data'][0]['price'].runtimeType}');
        print(
            'Data type of stock_quantity: ${data['data'][0]['stock_quantity'].runtimeType}');
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

  //lấy danh sách sản phẩm
  Future<List<Product>> getProductList() async {
    try {
      final response = await ApiService.getRequest('product/getProductList');

      if (response.statusCode == 200) {
        // print(response.body);
        final data = json.decode(response.body);
        print(data['success']);
        if (data['success']) {
          final product = (data['data'] as List)
              .map((productJson) => Product.fromJson(productJson))
              .toList();
          return product;
        } else {
          throw Exception('Failed to load products: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to load productsHomePage: ${response.statusCode}');
      }
    } catch (e) {
      throw e;
    }
  }
}
