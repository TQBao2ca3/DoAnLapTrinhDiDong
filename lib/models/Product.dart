class Product {
  final String id; // Thêm trường id
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
}
