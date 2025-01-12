class Product {
  final String title;
  final String description;
  final String image;
  final int price;
  final int discount;
  int quantity;
  String? size;

  Product({
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.discount,
    this.quantity = 1,
    this.size,
  });
}
