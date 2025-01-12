import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});
  @override
  _ChangePassword createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmNewPassword = TextEditingController();
  @override
  void dispose() {
    _oldPassword.dispose();
    _newPassword.dispose();
    _confirmNewPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        //automaticallyImplyLeading: false,
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
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
            ],
          ),
        ),
      ),
    );
  }
}
