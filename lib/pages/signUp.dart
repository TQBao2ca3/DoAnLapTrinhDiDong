import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phoneshop/pages/userAuthentication.dart';
import 'package:phoneshop/providers/Product_provider.dart';
import 'package:phoneshop/providers/user_provider.dart';
import 'package:phoneshop/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      final text = _phoneController.text;

      // Nếu không bắt đầu bằng "0", tự động thêm "0" vào đầu
      if (!text.startsWith('0')) {
        _phoneController.value = _phoneController.value.copyWith(
          text: '0$text',
          selection: TextSelection.collapsed(offset: text.length + 1),
        );
      }
    });
    //lấy ProductProvider và gọi loadProducts
    Future.microtask(() async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.register(
          username: _userNameController.text,
          password: _passwordController.text,
          email: _emailController.text,
          full_name: _fullNameController.text,
          phone: _phoneController.text);
      print("Đăng ký");
    });
  }

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _andressController = TextEditingController();

  _handleAuthentication() async {
    if (_userNameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      _showError('Vui lòng điền đầy đủ thông tin');
      return;
    }
  }

  _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  bool see = false;
  // Trong signUp.dart
  Future<void> register() async {
    // Validate các trường
    if (_userNameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      _showError('Vui lòng điền đầy đủ thông tin');
      return;
    }

    // Validate mật khẩu
    if (_passwordController.text.length < 6) {
      _showError('Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }

    // Validate email
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(_emailController.text)) {
      _showError('Email không hợp lệ');
      return;
    }

    // Validate số điện thoại
    final phoneRegExp = RegExp(r'^\d{10}$');
    if (!phoneRegExp.hasMatch(_phoneController.text)) {
      _showError('Số điện thoại không hợp lệ (phải có 10 chữ số)');
      return;
    }

    final url = Uri.parse('${ApiService.baseUrl}/user/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _userNameController.text,
          'password': _passwordController.text,
          'full_name': _fullNameController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
        }),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Thành công'),
                content: const Text('Đăng ký thành công'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const UserAuthentication()),
                      );
                    },
                    child: const Text('Đóng'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        String errorMessage = 'Đăng ký không thành công';
        if (responseData['message']?.contains('Username already exists') ??
            false) {
          errorMessage = 'Tên đăng nhập đã tồn tại';
        } else if (responseData['message']?.contains('Email already exists') ??
            false) {
          errorMessage = 'Email đã được sử dụng';
        } else if (responseData['message']?.contains('Phone already exists') ??
            false) {
          errorMessage = 'Số điện thoại đã được sử dụng';
        }
        _showError(errorMessage);
      }
    } catch (e) {
      _showError('Có lỗi xảy ra, vui lòng thử lại sau');
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _andressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Đăng ký",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          //scale full màn hình hiện tại sẽ lấy cả appbar nên nó dài hơn 1 xíu =))
          // height: MediaQuery.of(context).size.height,
          color: const Color(0xffEDECF2),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Icon người dùng
              const Icon(
                Icons.shop_two_rounded,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 30),

              // TextField Email
              TextField(
                controller: _userNameController,
                decoration: const InputDecoration(
                  labelText: 'Tài khoản',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),

              // TextField Password
              TextField(
                controller: _passwordController,
                obscureText: !see,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      see ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        see = !see; // Đảo trạng thái ẩn/hiện mật khẩu
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // TextField  fullname
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên',
                  prefixIcon: Icon(Icons.person_pin),
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 30),

              // TextField email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'example@example.com',
                ),
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(
                      r'[a-zA-Z0-9@._-]')), // Chỉ cho phép ký tự hợp lệ trong email
                ],
              ),
              const SizedBox(height: 30),

              // TextField [phone]
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: Icon(Icons.phone),
                  prefixText: "+84 ",
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]')), // Chỉ cho phép chữ và số
                ],
                maxLength: 10,
              ),
              const SizedBox(height: 30),

              // Nút đăng nhập/đăng ký
              ElevatedButton(
                onPressed: () {
                  _handleAuthentication();
                  register();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(152, 42),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xff03A9F4),
                ),
                child: const Text(
                  'Đăng ký',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),

              // Text và TextButton để chuyển đổi giữa đăng nhập và đăng ký
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Bạn đã có tài khoản? '),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserAuthentication()));
                    },
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
