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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar với nút quay lại và tiêu đề động
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Đăng nhập',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Color(0xffEDECF2),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text(
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

              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8),
                  child: TextButton(
                    onPressed: () {
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
                onPressed: () async {
                  // Xử lý logic đăng nhập/đăng ký ở đây
                  bool isAuthenticated = await MongoDatabase.authenticate(
                      _userNameController.text, _passwordController.text);
                  bool isAdmin = await MongoDatabase.checkAdmin(
                      _userNameController.text, _passwordController.text);
                  _handleAuthentication();
                  if (isAuthenticated) {
                    if (isAdmin) {
                      Navigator.pushNamed(context, "/");
                    } else {
                      Navigator.pushNamed(context, "cartPage");
                    }
                  } else {
                    _showError('Sai tài khoản hoặc mật khẩu');
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(152, 42),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xff03A9F4),
                ),
                child: Text(
                  'Đăng nhập',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),

              // Text và TextButton để chuyển đổi giữa đăng nhập và đăng ký
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bạn chưa có tài khoản? ',
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'signUp');
                    },
                    child: Text(
                      'Đăng ký',
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
