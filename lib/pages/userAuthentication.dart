import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:phoneshop/pages/ChangePassword.dart';
import 'dart:convert';

import 'package:phoneshop/pages/Homepage.dart';
import 'package:phoneshop/providers/Cart_Provider.dart';
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
  CartProvider cart = CartProvider();
  String _errorMessage = '';

  //login
  Future<void> login() async {
    final url = Uri.parse('http://192.168.1.4:3000/api/user/login');
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

        // In ra toàn bộ decoded token để kiểm tra cấu trúc
        print("Decoded token content: $decodedToken");

        final userIdFromToken = decodedToken['id'];
        print(
            "Raw userIdFromToken: $userIdFromToken (${userIdFromToken.runtimeType})");

        // In ra response data để kiểm tra
        print("Response data: $responseData");
        final userIdFromResponse = responseData['userId'];
        print(
            "Raw userIdFromResponse: $userIdFromResponse (${userIdFromResponse.runtimeType})");

        // Chuyển đổi sang int một cách an toàn
        int? userId;

        // Thử lấy từ token và in ra kết quả
        if (userIdFromToken != null) {
          userId = int.tryParse(userIdFromToken.toString());
          // print("userId từ token sau khi parse: $userId");
        }

        // Thử lấy từ response và in ra kết quả
        if (userId == null && userIdFromResponse != null) {
          userId = int.tryParse(userIdFromResponse.toString());
          //print("userId từ response sau khi parse: $userId");
        }

        // Kiểm tra và lưu vào Provider
        if (userId != null) {
          context.read<UserProvider>().setUserId(userId);
        } else {
          print("Không thể lấy được user ID hợp lệ");
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(cart: cart),
          ),
        );
      }
    } catch (e) {
      print("Error during login: $e");
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
