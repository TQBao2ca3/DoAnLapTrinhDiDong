import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:phoneshop/pages/userAuthentication.dart';
import 'package:phoneshop/providers/user_provider.dart';
import 'package:phoneshop/services/userPreference.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    print('UserInformation - initState called');

    // Sử dụng addPostFrameCallback để đảm bảo widget đã được build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserInformation();
    });
  }

  Future<void> _fetchUserInformation() async {
    print('UserInformation - Fetching user information');

    // Kiểm tra token trước khi fetch
    final token = await UserPreferences.getToken();
    if (token == null) {
      print('UserInformation - No token found');
      // Chuyển đến trang đăng nhập nếu không có token
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => UserAuthentication()));
      return;
    }

    // Truyền context khi gọi getUserInformation
    context.read<UserProvider>().getUserInformation(context);
  }

  // Các biến state giữ nguyên
  final Map<String, bool> _editingFields = {
    'name': false,
    'email': false,
    'phone': false,
    'address': false,
  };

  final Map<String, String> _userData = {
    'username': 'user1234',
    'name': 'name',
    'email': 'email',
    'phone': '0423145136',
    'address': 'HCMC',
  };

  final Map<String, String> _tempValues = {};

  // Các hàm xử lý giữ nguyên
  void _toggleEdit(String field) {
    setState(() {
      if (_editingFields[field]!) {
        _userData[field] = _tempValues[field] ?? _userData[field]!;
      } else {
        _tempValues[field] = _userData[field]!;
      }
      _editingFields[field] = !_editingFields[field]!;
    });
  }

  bool get isAnyFieldEditing => _editingFields.values.any((editing) => editing);

  @override
  Widget build(BuildContext context) {
    print('UserInformation - build called');
    // Sửa lại Consumer với type cụ thể
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        print('UserInformation - Consumer building');
        print('Loading state: ${userProvider.isLoading}');
        print('User data: ${userProvider.userData}');
        print('Error: ${userProvider.error}');

        return Scaffold(
          appBar: AppBar(
            title: Text(
              isAnyFieldEditing
                  ? 'Thông tin user đang sửa'
                  : 'Thông tin ${userProvider.userData['username']}',
              style: const TextStyle(fontSize: 18),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: Form(
            key: _formKey,
            child: userProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Tài khoản: User',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          // Sử dụng data từ userProvider
                          _buildInfoField(
                            label: 'Họ và tên:',
                            field: 'name',
                            value: userProvider.userData['full_name'] ?? '',
                          ),
                          _buildInfoField(
                            label: 'Email:',
                            field: 'email',
                            value: userProvider.userData['email'] ?? '',
                          ),
                          _buildInfoField(
                            label: 'SĐT:',
                            field: 'phone',
                            value: userProvider.userData['phone'] ?? '',
                          ),
                          _buildInfoField(
                            label: 'Địa chỉ:',
                            field: 'address',
                            value: userProvider.userData['address'] ?? '',
                          ),
                          // Các widget còn lại giữ nguyên
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: isAnyFieldEditing
                                ? () {
                                    setState(() {
                                      _editingFields.forEach((field, editing) {
                                        if (editing) {
                                          _userData[field] =
                                              _tempValues[field] ??
                                                  _userData[field]!;
                                          _editingFields[field] = false;
                                        }
                                      });
                                      _tempValues.clear();
                                    });
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isAnyFieldEditing ? Colors.blue : Colors.grey,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(200, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Cập nhật thông tin'),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: !isAnyFieldEditing ? () {} : null,
                            child: Text(
                              'Đổi mật khẩu',
                              style: TextStyle(
                                color: !isAnyFieldEditing
                                    ? Colors.red
                                    : Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildInfoField({
    required String label,
    String? field,
    required String value,
    bool editable = true,
  }) {
    bool isEditing = field != null && _editingFields[field] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: TextFormField(
              initialValue: isEditing ? (_tempValues[field] ?? value) : value,
              enabled: isEditing,
              onChanged: (newValue) {
                if (field != null) {
                  setState(() {
                    _tempValues[field] = newValue;
                  });
                }
              },
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
          ),
          if (editable)
            TextButton(
              onPressed: () => _toggleEdit(field!),
              child: Text(
                isEditing ? 'Hủy' : 'Sửa',
                style: const TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
