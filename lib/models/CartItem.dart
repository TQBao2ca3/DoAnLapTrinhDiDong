// lib/models/CartItem.dart
import 'package:phoneshop/models/Product.dart';

class CartItem {
  final int cart_id;
  final int cart_item_id;
  final String description;
  final int price; // Giữ nguyên kiểu int cho price
  int quantity;
  final String image_url;
  final String colors; // Giữ nguyên kiểu String cho colors
  final String storage; // Giữ nguyên kiểu String cho storage
  final String? storeName;

  CartItem({
    required this.cart_id,
    required this.cart_item_id,
    required this.description,
    required this.price,
    required this.quantity,
    required this.image_url,
    required this.colors,
    required this.storage,
    this.storeName,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    try {
      // Lấy giá trị đầu tiên từ mảng price
      List<dynamic> prices = json['price'] as List;
      int firstPrice = prices[0] as int;

      // Lấy giá trị đầu tiên từ mảng colors
      List<dynamic> colorsList = json['colors'] as List;
      String firstColor = colorsList[0] as String;

      // Lấy giá trị đầu tiên từ mảng storage
      List<dynamic> storageList = json['storage'] as List;
      String firstStorage = storageList[0] as String;

      return CartItem(
        cart_id: json['cart_id'] as int,
        cart_item_id: json['cart_item_id'] as int,
        description: json['description'] as String,
        image_url: json['image_url'] as String,
        price: firstPrice,
        storage: firstStorage,
        colors: firstColor,
        quantity: json['quantity'] as int,
        storeName: 'Phone Shop', // Default value
      );
    } catch (e) {
      print('Error parsing CartItem from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  // Các phương thức khác giữ nguyên
}
