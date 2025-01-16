import 'package:flutter/material.dart';
import 'package:phoneshop/models/Cart.dart';
import 'package:phoneshop/pages/UserAuthentication.dart';
import 'package:phoneshop/providers/ProductHomePage_Provider.dart';
import 'package:phoneshop/providers/Product_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      //ChangeNotifierProvider(create: (_) => ProductDetailProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => ProductHomePageProvider()),
      //ChangeNotifierProvider(create: (_) => CategoryProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final Cart cart = Cart();

  MyApp({super.key}); // Sử dụng Cart từ models/cart.dart

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserAuthentication(),
    );
  }
}
