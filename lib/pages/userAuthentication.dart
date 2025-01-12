import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phoneshop/models/Cart.dart';
import 'package:phoneshop/pages/ChangePassword.dart';
import 'dart:convert';

import 'package:phoneshop/pages/Homepage.dart';

class UserAuthentication extends StatefulWidget {
  const UserAuthentication({super.key});

  @override
  _UserAuthenticationState createState() => _UserAuthenticationState();
}

class _UserAuthenticationState extends State<UserAuthentication> {
// Controller để lấy dữ liệu từ TextField
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Cart cart = Cart();
  String _errorMessage = '';

  Future<void> login() async {
    try {
      print('Đang thực hiện đăng nhập:');
      print('Username: ${_userNameController.text}');
      print('Password: ${_passwordController.text}');

      final url = Uri.parse('http://192.168.1.3:3000/api/user/login');
      print('Sending request to: $url');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _userNameController.text,
          'password': _passwordController.text,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body raw: ${response.body}');

      final responseData = jsonDecode(response.body);
      print('Response data decoded: $responseData');

      if (response.statusCode == 200) {
        print('Login successful');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(cart: cart)),
        );
      } else {
        print('Login failed. Status: ${response.statusCode}, Error: ${responseData['error'] ?? 'Unknown error'}');
        setState(() {
          _errorMessage = responseData['message'] ?? 'Login failed';
        });
      }
    } catch (e, stackTrace) {
      print('Error during login: $e');
      print('Stack trace: $stackTrace');  // Thêm stack trace
      setState(() {
        _errorMessage = 'Connection error: ${e.toString()}';
      });
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
                  backgroundColor: Color(0xff03A9F4),
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
