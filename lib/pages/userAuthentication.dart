import 'package:flutter/material.dart';
import 'package:phoneshop/admin/TrangChu.dart';
import 'package:phoneshop/pages/ChangePassword.dart';
import 'dart:convert';

import 'package:phoneshop/pages/Homepage.dart';
import 'package:phoneshop/pages/signUp.dart';
import 'package:phoneshop/providers/CartItems_Provider.dart';
import 'package:phoneshop/providers/user_provider.dart';
import 'package:phoneshop/services/api_service.dart';
import 'package:phoneshop/services/userPreference.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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
      await cartItemProvider.loadCartItems();
    }
  }

  // userAuthentication.dart
  Future<void> login() async {
    if (_userNameController.text.isEmpty || _passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Thông báo'),
            content: const Text('Vui lòng nhập đầy đủ tài khoản và mật khẩu'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ],
          );
        },
      );
      return;
    }
    try {
      final responseUser = await http.post(
        Uri.parse("${ApiService.baseUrl}/user/login"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': _userNameController.text,
          'password': _passwordController.text,
        }),
      );
      final responseAdmin = await http.post(
        Uri.parse("${ApiService.baseUrl}/login"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': _userNameController.text,
          'password': _passwordController.text,
        }),
      );
      final responseData = jsonDecode(responseUser.body);
      if (responseAdmin.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(responseAdmin.body);
        final user = data['user'];
        if (_userNameController.text == "admin") {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminOrdersScreen(user: user)),
            );
          }
          return; // Thêm return ở đây để không chạy tiếp code user
        } else {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);

          // Gọi login từ UserProvider
          final result = await userProvider.login(
            _userNameController.text,
            _passwordController.text,
          );

          if (mounted) {
            if (result) {
              // Khởi tạo CartProvider với userId
              final userId = await UserPreferences.getUserId();
              if (userId != null) {
                await context.read<CartProvider>().initializeWithUserId(userId);
              }
              // Login thành công, chuyển đến HomeScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            }
          }
        }
      } else if (responseUser.statusCode == 401) {
        print(responseUser.statusCode);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            String errorMessage = 'Sai tài khoản hoặc mật khẩu';
            switch (responseUser.statusCode) {
              case 401:
                if (responseData['message']?.contains('User not found') ??
                    false) {
                  errorMessage = 'Tài khoản không tồn tại';
                } else if (responseData['message']
                        ?.contains('Invalid credentials') ??
                    false) {
                  errorMessage = 'Mật khẩu không chính xác';
                }
                break;
              case 500:
                errorMessage = 'Lỗi máy chủ. Vui lòng thử lại sau';
                break;
              default:
                errorMessage = responseData['message'] ??
                    'Tài khoản hoặc mật khẩu admin không chính xác';
            }
            return AlertDialog(
              title: const Text('Lỗi'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Đóng'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Xử lý lỗi kết nối cho admin
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Lỗi'),
              content: Text("Lỗi kết nối"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Đóng'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  bool see = false;
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()));
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
