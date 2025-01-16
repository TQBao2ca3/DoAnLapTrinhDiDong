class Product {
  final int id; // Thêm trường id
  final String title;
  final String description;
  final String image;
  final int price;
  final int originalPrice; // Thêm giá gốc
  final int discount;
  final double rating;
  final int reviewCount;
  final List<String> storage;
  final List<String> colors;
  final DateTime createAt; // Thêm thuộc tính ngày sản xuất
  int quantity;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.originalPrice,
    this.discount = 0,
    this.rating = 4.9,
    this.reviewCount = 668,
    required this.storage,
    required this.colors, // Đặt yêu cầu màu sắc
    required this.createAt, // Đặt yêu cầu ngày sản xuất
    this.quantity = 1,
  });

  //convert Map to dart object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
      originalPrice: json['originalPrice'],
      storage: json['storage'],
      colors: json['colors'],
      createAt: json['createAt'],
    );
  }

  //convert dart object to Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'originalPrice': originalPrice,
      'storage': storage,
      'colors': colors,
      'createAt': createAt,
    };
  }
}
