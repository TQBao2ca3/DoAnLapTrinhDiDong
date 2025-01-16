//models/product_detail_model.dart
class Product_Detail {
  final int product_detail_id;
  final int product_id;
  final String storage;
  final double price;
  final int stock_quantity;
  final String image_url;
  final String description;
  final String colors;
  final int is_active;

  Product_Detail(
      {required this.product_detail_id,
      required this.product_id,
      required this.storage,
      required this.price,
      required this.stock_quantity,
      required this.image_url,
      required this.description,
      required this.colors,
      required this.is_active});

  //covert Map to dart object
  factory Product_Detail.fromJson(Map<String, dynamic> json) {
    return Product_Detail(
      product_detail_id: json['product_detail_id'],
      product_id: json['product_id'],
      storage: json['storage'],
      price: json['price'],
      stock_quantity: json['stock_quantity'],
      image_url: json['image_url'],
      description: json['description'],
      colors: json['colors'],
      is_active: json['is_active'],
    );
  }

  //convert dart object to Map
  Map<String, dynamic> toJson() {
    return {
      'product_detail_id': product_detail_id,
      'product_id': product_id,
      'storage': storage,
      'price': price,
      'stock_quantity': stock_quantity,
      'image_url': image_url,
      'description': description,
      'colors': colors,
      'is_active': is_active,
    };
  }
}
