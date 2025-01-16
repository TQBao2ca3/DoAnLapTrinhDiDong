import 'package:flutter/material.dart';
import 'package:phoneshop/models/Product.dart';

// ValueNotifier để quản lý danh sách sản phẩm yêu thích
final favoriteProductsNotifier = ValueNotifier<List<Product>>([]);

// Thêm sản phẩm vào danh sách yêu thích
void addFavoriteProduct(Product product) {
  final currentList = List<Product>.from(favoriteProductsNotifier.value);
  if (!currentList.any((p) => p.id == product.id)) {
    currentList.add(product);
    favoriteProductsNotifier.value = currentList;
  }
}

// Xóa sản phẩm khỏi danh sách yêu thích
void removeFavoriteProduct(Product product) {
  final currentList = List<Product>.from(favoriteProductsNotifier.value);
  currentList.removeWhere((p) => p.id == product.id);
  favoriteProductsNotifier.value = currentList;
}

// Kiểm tra xem một sản phẩm có trong danh sách yêu thích không
bool isProductFavorite(Product product) {
  return favoriteProductsNotifier.value.any((p) => p.id == product.id);
}