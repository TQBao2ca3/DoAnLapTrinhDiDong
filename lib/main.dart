import 'package:flutter/material.dart';
import 'package:phoneshop/pages/UserAuthentication.dart';
import 'package:phoneshop/providers/Cart_Provider.dart';
import 'package:phoneshop/providers/ProductHomePage_Provider.dart';
import 'package:phoneshop/providers/Product_provider.dart';
import 'package:phoneshop/providers/User_Provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => ProductHomePageProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final CartProvider cart = CartProvider();

  MyApp({super.key}); // Sử dụng Cart từ models/cart.dart

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserAuthentication(),
    );
  }
}
