import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
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
<<<<<<< HEAD
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(
            fontSize: 20,
=======
      // AppBar với nút quay lại và tiêu đề động
      appBar: AppBar(
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(
            fontSize: 28,
>>>>>>> xuanhoangd
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
<<<<<<< HEAD
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          color: const Color(0xffEDECF2),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Tên tài khoản: user',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      'Mật khẩu cũ: ',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                        constraints: const BoxConstraints(maxHeight: 40),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(height: 1.0),
                          controller: _oldPassword,
                          decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder()),
                        )),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      'Mật khẩu mới: ',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                        constraints: const BoxConstraints(maxHeight: 40),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(height: 1.0),
                          obscureText: true,
                          controller: _newPassword,
                          decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder()),
                        )),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      'Xác nhận MK: ',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                        constraints: const BoxConstraints(maxHeight: 40),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(height: 1.0),
                          obscureText: true,
                          controller: _confirmNewPassword,
                          decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder()),
                        )),
                  )
                ],
              ),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(152, 52),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xff03A9F4)),
                  child: const Text('Đổi mật khẩu'))
=======

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
>>>>>>> xuanhoangd
            ],
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi widget bị hủy
    _comfirmPass.dispose();
    _newPass.dispose();
    _oldPass.dispose();
    super.dispose();
  }
>>>>>>> xuanhoangd
}
