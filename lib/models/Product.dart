class Product {
  final int product_id;
  final String name;
  final String description;
  final String image_url;
  final List<int> price; // Đổi thành List<int> thay vì List<double>
  final int discount;
  final double rating;
  final int reviewCount;
  final List<String> storage;
  final List<String> colors;
  final DateTime created_at;
  int stock_quantity;

  Product({
    required this.product_id,
    required this.name,
    required this.description,
    required this.image_url,
    required this.price,
    this.discount = 0,
    this.rating = 4.9,
    this.reviewCount = 668,
    required this.storage,
    required this.colors,
    required this.created_at,
    required this.stock_quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      return Product(
        product_id: json['product_id'],
        name: json['name'],
        description: json['description'],
        image_url: json['image_url'],
        price: List<int>.from(json['price']), // Sử dụng List.from để convert
        storage: List<String>.from(json['storage']),
        colors: List<String>.from(json['colors']),
        created_at: DateTime.parse(json['created_at']),
        stock_quantity: json['stock_quantity'],
      );
    } catch (e) {
      print('Error parsing product: $e');
      rethrow;
    }
  }

  // Thêm phương thức toJson nếu cần
  Map<String, dynamic> toJson() {
    return {
      'product_id': product_id,
      'name': name,
      'description': description,
      'image_url': image_url,
      'price': price,
      'discount': discount,
      'rating': rating,
      'reviewCount': reviewCount,
      'storage': storage,
      'colors': colors,
      'created_at': created_at.toIso8601String(),
      'stock_quantity': stock_quantity,
    };
  }
}
