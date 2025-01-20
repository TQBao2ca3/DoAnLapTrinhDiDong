import 'package:flutter/material.dart';
import 'package:phoneshop/pages/userAuthentication.dart';
import 'package:provider/provider.dart';
import 'package:phoneshop/providers/user_provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  bool _isLoading = false;

  void _showMessage(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  bool seeOldPass = false;
  bool seeNewPass = false;
  bool seeConfirmPass = false;
  // Trong ChangePassword.dart
  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_newPass.text.length < 6) {
      _showMessage('Mật khẩu mới phải có ít nhất 6 ký tự', true);
      return;
    }

    if (_newPass.text == _oldPass.text) {
      _showMessage('Mật khẩu mới phải khác mật khẩu hiện tại', true);
      return;
    }

    if (_newPass.text != _confirmPass.text) {
      _showMessage('Mật khẩu xác nhận không khớp', true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await context.read<UserProvider>().changePassword(
            _oldPass.text,
            _newPass.text,
          );

      if (!mounted) return;

      final userProvider = context.read<UserProvider>();
      if (userProvider.error != null) {
        String errorMessage = userProvider.error!;
        if (errorMessage.contains('Incorrect old password')) {
          _showMessage('Mật khẩu hiện tại không đúng', true);
        } else {
          _showMessage(errorMessage, true);
        }
      } else {
        _showMessage('Đổi mật khẩu thành công', false);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => UserAuthentication()));
      }
    } catch (e) {
      _showMessage('Có lỗi xảy ra: $e', true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: _oldPass,
                obscureText: !seeOldPass,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu cũ',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      seeOldPass ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        seeOldPass =
                            !seeOldPass; // Đảo trạng thái ẩn/hiện mật khẩu
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu cũ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _newPass,
                obscureText: !seeNewPass,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu mới',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      seeNewPass ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        seeNewPass =
                            !seeNewPass; // Đảo trạng thái ẩn/hiện mật khẩu
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu mới';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPass,
                obscureText: !seeConfirmPass,
                decoration: InputDecoration(
                  labelText: 'Xác nhận mật khẩu mới',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      seeConfirmPass ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        seeConfirmPass =
                            !seeConfirmPass; // Đảo trạng thái ẩn/hiện mật khẩu
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu mới';
                  }
                  if (value != _newPass.text) {
                    return 'Mật khẩu xác nhận không khớp';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleChangePassword,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Đổi mật khẩu'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _oldPass.dispose();
    _newPass.dispose();
    _confirmPass.dispose();
    super.dispose();
  }
}
