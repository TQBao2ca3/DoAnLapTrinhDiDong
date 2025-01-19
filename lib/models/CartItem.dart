// lib/models/CartItem.dart

class CartItem {
  final int cart_id;
  final int cart_item_id;
  final int product_detail_id; // Thêm field mới
  final String description;
  final int price;
  int quantity;
  final String image_url;
  final String colors;
  final String storage;
  final String? storeName;

  CartItem({
    required this.cart_id,
    required this.cart_item_id,
    required this.product_detail_id, // Thêm vào constructor
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
      // Sửa lại cách parse dữ liệu
      return CartItem(
        cart_id: json['cart_id'] as int,
        cart_item_id: json['cart_item_id'] as int,
        product_detail_id: json['product_detail_id'] as int,
        description: json['name'] ??
            json['description'], // Sử dụng tên sản phẩm làm description
        image_url: json['image_url'] as String,
        price: json['price'] as int, // Parse trực tiếp thành int
        storage: json['storage'] as String, // Parse trực tiếp thành String
        colors: json['colors'] as String, // Parse trực tiếp thành String
        quantity: json['quantity'] as int,
        storeName: 'Phone Shop',
      );
    } catch (e) {
      print('Error parsing CartItem from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
}
