import 'package:flutter/material.dart';
import 'package:phoneshop/pages/Homepage.dart';
import 'package:phoneshop/pages/UserAuthentication.dart';
import 'package:phoneshop/providers/CartItems_Provider.dart';
import 'package:phoneshop/providers/Product_provider.dart';
import 'package:phoneshop/services/userPreference.dart';
import 'package:provider/provider.dart';
import 'package:phoneshop/providers/user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await UserPreferences.getToken();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      // ChangeNotifierProvider(create: (_) => ProductHomePageProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
    child: MyApp(isLogin: token != null),
  ));
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  MyApp({super.key, required this.isLogin}); // Sử dụng Cart từ models/cart.dart

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLogin ? HomeScreen() : UserAuthentication(),
    );
  }
}
