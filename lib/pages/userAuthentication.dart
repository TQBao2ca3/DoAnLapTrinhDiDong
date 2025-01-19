import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:phoneshop/models/Cart.dart';
import 'package:phoneshop/pages/ChangePassword.dart';
import 'package:phoneshop/pages/Homepage.dart';
import 'package:phoneshop/pages/SignUp.dart';

class UserAuthentication extends StatefulWidget {
  const UserAuthentication({super.key});

  @override
  _UserAuthenticationState createState() => _UserAuthenticationState();
}

class _UserAuthenticationState extends State<UserAuthentication> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Cart cart = Cart();
  String _errorMessage = '';
  bool _isPasswordVisible = false;

  Future<void> login() async {
    try {
      final url = Uri.parse('http://192.168.1.6:3000/api/user/login');
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(cart: cart)),
        );
      } else {
        setState(() {
          _errorMessage = responseData['message'] ?? 'Login failed';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header với gradient
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[700]!, Colors.blue[500]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48), // Để cân bằng với nút back
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Icon điện thoại
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.phone_iphone,
                      size: 40,
                      color: Colors.blue[600],
                    ),
                  ),
                ],
              ),
            ),

            // Form đăng nhập
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Chào mừng quay trở lại H2DB Mobile!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Đăng nhập để tiếp tục mua sắm',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // TextField Username
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[300]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _userNameController,
                        decoration: InputDecoration(
                          labelText: 'Tài khoản',
                          hintText: 'Nhập tên tài khoản',
                          prefixIcon:
                              Icon(Icons.person, color: Colors.blue[600]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // TextField Password
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[300]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          hintText: 'Nhập mật khẩu',
                          prefixIcon: Icon(Icons.lock, color: Colors.blue[600]),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.blue[600],
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),

                    // Quên mật khẩu
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChangePassword(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Quên mật khẩu?',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (_errorMessage.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red[700]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage,
                                style: TextStyle(color: Colors.red[700]),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Bottom buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: const Size(double.infinity, 55),
                      elevation: 2,
                    ),
                    child: const Text(
                      "Đăng nhập",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Chưa có tài khoản? ',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUp(),
                            ),
                          );
                        },
                        child: Text(
                          'Đăng ký ngay',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
