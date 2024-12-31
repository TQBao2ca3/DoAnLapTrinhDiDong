import 'package:flutter/material.dart';
import 'package:phoneshop/database/mongodbConnect.dart';

class UserAuthentication extends StatefulWidget {
  const UserAuthentication({super.key});

  @override
  _UserAuthenticationState createState() => _UserAuthenticationState();
}

class _UserAuthenticationState extends State<UserAuthentication> {
  @override
  void initState() {
    super.initState();
    _connectToMongoDB();
  }

  _connectToMongoDB() async {
    await MongoDatabase.connect();
  }

  _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Controller để lấy dữ liệu từ TextField
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // ignore: unused_element
  _handleAuthentication() async {
    if (_userNameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError('Vui lòng điền đầy đủ thông tin');
      return;
    }
  }

  // Biến để kiểm tra xem đang ở chế độ đăng nhập hay đăng ký
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar với nút quay lại và tiêu đề động
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        title: Text(
          isLogin ? 'Đăng nhập' : 'Đăng ký',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                ),
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
                ),
              ),
              const SizedBox(height: 30),

              // Nút đăng nhập/đăng ký
              ElevatedButton(
                onPressed: () async {
                  // Xử lý logic đăng nhập/đăng ký ở đây
                  bool isAuthenticated = await MongoDatabase.authenticate(
                      _userNameController.text, _passwordController.text);
                  bool isAdmin = await MongoDatabase.checkAdmin(
                      _userNameController.text, _passwordController.text);
                  _handleAuthentication();
                  if (isLogin) {
                    if (isAuthenticated) {
                      if (isAdmin) {
                        Navigator.pushNamed(context, "/");
                      } else {
                        Navigator.pushNamed(context, "cartPage");
                      }
                    } else {
                      _showError('Sai tài khoản hoặc mật khẩu');
                    }
                  } else {
                    // if (isAuthenticated) {
                    //   _showError('Tài khoản đã tồn tại');
                    // } else {
                    //   await MongoDatabase.insert(
                    //       _userNameController.text, _passwordController.text);
                    //   Navigator.pop(context);
                    // }
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  isLogin ? 'Đăng nhập' : 'Đăng ký',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),

              // Text và TextButton để chuyển đổi giữa đăng nhập và đăng ký
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin
                        ? 'Bạn chưa có tài khoản? '
                        : 'Bạn đã có tài khoản? ',
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin ? 'Đăng ký' : 'Đăng nhập',
                      style: const TextStyle(
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
