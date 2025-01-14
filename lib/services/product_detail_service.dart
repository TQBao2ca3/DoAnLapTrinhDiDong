import 'dart:convert';

import 'package:phoneshop/models/Product_detail_model.dart';
import 'package:phoneshop/services/api_service.dart';

class ProductDetailService {
  //lấy chi tiết sản phẩm
  Future<Product_Detail> getDetail(int productID) async {
    print('service id: $productID');
    final response = await ApiService.getRequest(
        'productdetail/getProductDetail/$productID');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      print("Failed to load products");
      throw Exception('Failed to load products');
    }
  }
}
