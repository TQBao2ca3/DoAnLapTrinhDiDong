import 'package:flutter/material.dart';
import 'package:phoneshop/models/Cart.dart';
import 'package:phoneshop/models/Product.dart';
import 'package:phoneshop/pages/CartPage.dart';
import 'package:phoneshop/pages/Homepage.dart';
import 'package:phoneshop/pages/ItemPage.dart';
import 'package:phoneshop/pages/UserAuthentication.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Cart cart = Cart(); // Sử dụng Cart từ models/cart.dart

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(cart: cart),
        'cartPage': (context) => CartPage(cart: cart),
        'itemPage': (context) => ItemPage(
              product: ModalRoute.of(context)!.settings.arguments as Product,
            ),
        'userAuthentication': (context) => UserAuthentication(),
      },
    );
  }
}
