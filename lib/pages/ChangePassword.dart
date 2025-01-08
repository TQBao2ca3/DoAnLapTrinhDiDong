import 'package:flutter/material.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<Changepassword> {
  @override
  _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Controller để lấy dữ liệu từ TextField
  final TextEditingController _oldPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _comfirmPass = TextEditingController();
  // ignore: unused_element
  _handleAuthentication() async {
    if (_oldPass.text.isEmpty ||
        _newPass.text.isEmpty ||
        _comfirmPass.text.isEmpty) {
      _showError('Vui lòng điền đầy đủ thông tin');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar với nút quay lại và tiêu đề động
      appBar: AppBar(
        title: const Text(
          'Đổi mật khẩu',
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
                controller: _oldPass,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu cũ',
                  prefixText: 'Mật khẩu cũ: ',
                  // prefixStyle: TextStyle(),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // TextField Password
              TextField(
                controller: _newPass,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu mới',
                  prefixText: 'Mật khẩu mới: ',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _newPass,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Xác nhận mật khẩu mới',
                  prefixText: 'Xác nhận MK: ',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              const SizedBox(height: 50),
              // Nút đăng nhập/đăng ký
              ElevatedButton(
                onPressed: () {
                  _handleAuthentication();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(152, 42),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xff03A9F4),
                ),
                child: const Text(
                  'Đổi mật khẩu',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),

              // Text và TextButton để chuyển đổi giữa đăng nhập và đăng ký
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi widget bị hủy
    _comfirmPass.dispose();
    _newPass.dispose();
    _oldPass.dispose();
    super.dispose();
  }
}
