import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:phoneshop/models/CartItem.dart';
import 'package:phoneshop/pages/ChangePassword.dart';
import 'dart:convert';

import 'package:phoneshop/pages/Homepage.dart';
import 'package:phoneshop/providers/CartItems_Provider.dart';
import 'package:phoneshop/providers/User_Provider.dart';
import 'package:provider/provider.dart';

class UserAuthentication extends StatefulWidget {
  const UserAuthentication({super.key});

  @override
  _UserAuthenticationState createState() => _UserAuthenticationState();
}

class _UserAuthenticationState extends State<UserAuthentication> {
// Controller để lấy dữ liệu từ TextField
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //CartProvider cart = CartProvider();
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadCartItem() async {
    final cartItemProvider = Provider.of<CartProvider>(context, listen: false);
    final cart_id = context.watch<CartProvider>().cart_id;
    if (cartItemProvider.items.isEmpty) {
      await cartItemProvider.loadCartItems(cart_id);
    }
  }

  //login
  Future<void> login() async {
    final url = Uri.parse('http://192.168.250.252:3000/api/user/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _userNameController.text,
          'password': _passwordController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = responseData['token'];
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        // Lấy user_id và cart_id từ token
        final userIdFromToken = decodedToken['id'];
        final cartIdFromToken = decodedToken['cart_id'];

        // Lấy user_id và cart_id từ response
        final userIdFromResponse = responseData['userId'];
        final cartIdFromResponse = responseData['cartId'];

        // Chuyển đổi userId và cartId sang int một cách an toàn
        int? userId;
        int? cartId;

        // Ưu tiên lấy từ token
        if (userIdFromToken != null) {
          userId = int.tryParse(userIdFromToken.toString());
        }
        if (cartIdFromToken != null) {
          cartId = int.tryParse(cartIdFromToken.toString());
        }

        // Nếu không có trong token thì lấy từ response
        if (userId == null && userIdFromResponse != null) {
          userId = int.tryParse(userIdFromResponse.toString());
        }
        if (cartId == null && cartIdFromResponse != null) {
          cartId = int.tryParse(cartIdFromResponse.toString());
        }

        // Lưu userId vào UserProvider
        if (userId != null) {
          context.read<UserProvider>().setUserId(userId);
        }

        // Lưu cartId vào CartProvider và load danh sách cartItem
        if (cartId != null) {
          print('CartId received: $cartId'); // Thêm log
          final cartProvider = context.read<CartProvider>();
          cartProvider.setCartId(cartId);
          print('CartId set in provider'); // Thêm log
          try {
            print('Loading cart items...'); // Thêm log
            await cartProvider.loadCartItems(cartId);
            print(
                'Cart items loaded. Items count: ${cartProvider.items.length}'); // Thêm log
          } catch (e) {
            print('Error loading cart items: $e'); // Thêm log
          }
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
      }
    } catch (e) {
      print("Error during login: $e");
      // Có thể thêm thông báo lỗi cho người dùng ở đây
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar với nút quay lại và tiêu đề động
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Đăng nhập',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: const Color(0xffEDECF2),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Đăng nhập',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 60),

              // TextField Email
              TextField(
                controller: _userNameController,
                decoration: const InputDecoration(
                    labelText: 'Tài khoản',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true),
              ),
              const SizedBox(height: 20),

              // TextField Password
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Mật khẩu',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true),
              ),

              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword()));
                      // Xử lý quên mật khẩu
                      Navigator.pushNamed(context, 'changePassword');
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Quên mật khẩu',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              // Nút đăng nhập/đăng ký
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(152, 42),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xff03A9F4),
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),

              // Text và TextButton để chuyển đổi giữa đăng nhập và đăng ký
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bạn chưa có tài khoản? ',
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'signUp');
                    },
                    child: const Text(
                      'Đăng ký',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi widget bị hủy
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
