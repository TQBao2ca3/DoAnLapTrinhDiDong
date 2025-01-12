import 'package:flutter/material.dart';
import 'package:phoneshop/models/Cart.dart';
import 'package:phoneshop/models/Product.dart';
import 'package:phoneshop/pages/CartPage.dart';
import 'package:phoneshop/pages/ChangePassword.dart';
import 'package:phoneshop/pages/Homepage.dart';
import 'package:phoneshop/pages/ItemPage.dart';
import 'package:phoneshop/pages/UserAuthentication.dart';
import 'package:phoneshop/pages/UserInformation.dart';
import 'package:phoneshop/pages/signUp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Cart cart = Cart();

  MyApp({super.key}); // Sử dụng Cart từ models/cart.dart

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: 'userAuthentication',
      routes: {
        '/': (context) => HomeScreen(cart: cart),
        'cartPage': (context) => CartPage(cart: cart),
        'itemPage': (context) => ItemPage(
              product: ModalRoute.of(context)!.settings.arguments as Product,
            ),
        'userAuthentication': (context) => const UserAuthentication(),
        'signUp': (context) => const SignUp(),
        'changePassword': (context) => const Changepassword(),
        'userInformation': (context) => const UserInformation(),
      },
    );
  }
}
