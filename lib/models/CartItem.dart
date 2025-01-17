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
      List<dynamic> prices = json['price'] as List;
      int firstPrice = prices[0] as int;

      List<dynamic> colorsList = json['colors'] as List;
      String firstColor = colorsList[0] as String;

      List<dynamic> storageList = json['storage'] as List;
      String firstStorage = storageList[0] as String;

      return CartItem(
        cart_id: json['cart_id'] as int,
        cart_item_id: json['cart_item_id'] as int,
        product_detail_id:
            json['product_detail_id'] as int, // Thêm vào fromJson
        description: json['description'] as String,
        image_url: json['image_url'] as String,
        price: firstPrice,
        storage: firstStorage,
        colors: firstColor,
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
