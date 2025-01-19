class ProductHomePage {
  final int product_id;
  final String name;
  final String description;
  final String image_url;

  ProductHomePage({
    required this.product_id,
    required this.name,
    required this.description,
    required this.image_url,
  });

  //convert map to dart object
  factory ProductHomePage.fromJson(Map<String, dynamic> json) {
    return ProductHomePage(
      product_id: json['product_id'],
      name: json['name'],
      description: json['description'],
      image_url: json['image_url'],
    );
  }
}
