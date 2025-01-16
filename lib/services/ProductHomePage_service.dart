import 'dart:convert';

import 'package:phoneshop/models/ProductHomePage.dart';
import 'package:phoneshop/services/Api_service.dart';

class ProductHomePageService {
  //lấy danh sách sản phẩm
  Future<List<ProductHomePage>> getProductHomePage() async {
    try {
      final response =
          await ApiService.getRequest('productHomePage/getProductHomePageList');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          final productsHomePage = (data['data'] as List)
              .map((productJson) => ProductHomePage.fromJson(productJson))
              .toList();
          return productsHomePage;
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
