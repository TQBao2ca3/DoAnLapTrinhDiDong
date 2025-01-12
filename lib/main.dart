import 'package:flutter/material.dart';
import 'package:phoneshop/models/Cart.dart';
import 'package:phoneshop/pages/UserAuthentication.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Cart cart = Cart();

  MyApp({super.key}); // Sử dụng Cart từ models/cart.dart

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UserAuthentication(),
    );
  }
}
