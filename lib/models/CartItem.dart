// lib/models/CartItem.dart
import 'package:phoneshop/models/Product.dart';

class CartItem {
  final int id;
  final String name;
  final int price;
  final int originalPrice; // Giá gốc trước giảm
  final int quantity;
  final String image;
  final String color;
  final String storage;
  final String? storeName;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.quantity,
    required this.image,
    required this.color,
    required this.storage,
    this.storeName,
  });

  // Convert from Product to CartItem
  factory CartItem.fromProduct(Product product) {
    return CartItem(
      id: product.product_id,
      name: product.name,
      price: product.price[0],
      originalPrice: product.price[0],
      quantity: product.stock_quantity,
      image: product.image_url,
      color: product.colors.first,
      storage: product.storage.first,
      storeName: 'Phone Shop',
    );
  }

  int get totalPrice => price * quantity;
}
