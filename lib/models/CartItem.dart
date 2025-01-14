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
  final String? storeName;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.quantity,
    required this.image,
    required this.color,
    this.storeName,
  });

  // Convert from Product to CartItem
  factory CartItem.fromProduct(Product product) {
    return CartItem(
      id: product.id,
      name: product.title,
      price: product.price,
      originalPrice: product.originalPrice ?? product.price,
      quantity: product.quantity,
      image: product.image,
      color: product.colors.first,
      storeName: 'Phone Shop',
    );
  }

  int get totalPrice => price * quantity;
}
