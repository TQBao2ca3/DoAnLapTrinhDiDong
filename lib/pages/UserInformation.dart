import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phoneshop/pages/ChangePassword.dart';
import 'package:phoneshop/pages/Homepage.dart';
import 'package:phoneshop/pages/userAuthentication.dart';
import 'package:phoneshop/providers/user_provider.dart';
import 'package:phoneshop/services/userPreference.dart';
import 'package:provider/provider.dart';

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

    // addPostFrameCallback để đảm bảo widget đã được build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserInformation();
    });
  }

  bool cancelUpdate = false;
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
  void _toggleEdit(String field) {
    setState(() {
      if (_editingFields[field]!) {
        // Khi nhấn lưu, gọi phương thức update
        if (_tempValues[field] != null &&
            _tempValues[field] != _userData[field] &&
            cancelUpdate == false) {
          _updateSpecificField(field, _tempValues[field]!);
        }
        _userData[field] = _tempValues[field] ?? _userData[field]!;
      } else {
        _tempValues[field] = _userData[field]!;
      }
      _editingFields[field] = !_editingFields[field]!;
    });
  }

  void _updateSpecificField(String field, String value) {
    final Map<String, String> fieldMapping = {
      'name': 'full_name',
      'email': 'email',
      'phone': 'phone',
      'address': 'address'
    };

    // Gọi phương thức update từ provider
    context.read<UserProvider>().updateUserProfile(
          context,
          full_name: field == 'name' ? value : null,
          email: field == 'email' ? value : null,
          phone: field == 'phone' ? value : null,
          address: field == 'address' ? value : null,
        );
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

        // if (userProvider.error != null) {
        //   return Center(
        //     child: Text(
        //       'Error: ${userProvider.error}',
        //       style: const TextStyle(color: Colors.red),
        //     ),
        //   );
        // }
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
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                cancelUpdate = true;
                Navigator.pop(context);
              },
            ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Tài khoản: ${userProvider.userData['username']}",
                                style: const TextStyle(
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
                                    // if (userProvider.error
                                    //         ?.contains('message') ==
                                    //     "Email already exists") {
                                    //   AlertDialog(
                                    //     title: const Text('Cập nhật thất bại'),
                                    //     content:
                                    //         const Text('Email đã được sử dụng'),
                                    //     actions: <Widget>[
                                    //       TextButton(
                                    //         onPressed: () {
                                    //           Navigator.of(context)
                                    //               .pop(); // Đóng dialog
                                    //         },
                                    //         child: Text('OK'),
                                    //       ),
                                    //     ],
                                    //   );
                                    // } else if (userProvider.error
                                    //         ?.contains('message') ==
                                    //     "Phone already exists") {
                                    //   AlertDialog(
                                    //     title: const Text('Cập nhật thất bại'),
                                    //     content: const Text(
                                    //         'Số điện thoại đã được sử dụng'),
                                    //     actions: <Widget>[
                                    //       TextButton(
                                    //         onPressed: () {
                                    //           Navigator.of(context)
                                    //               .pop(); // Đóng dialog
                                    //         },
                                    //         child: Text('OK'),
                                    //       ),
                                    //     ],
                                    //   );
                                    // }
                                    userProvider.error?.contains('message');
                                    // Kiểm tra form validation nếu cần
                                    if (_formKey.currentState!.validate()) {
                                      // Tạo map chứa các field cần update
                                      Map<String, String> updatedFields = {};

                                      // Duyệt qua các field đang được editing
                                      _editingFields
                                          .forEach((field, isEditing) {
                                        if (isEditing &&
                                            _tempValues[field] != null &&
                                            _tempValues[field] !=
                                                _userData[field]) {
                                          switch (field) {
                                            case 'name':
                                              updatedFields['full_name'] =
                                                  _tempValues[field]!;
                                              break;
                                            case 'email':
                                              updatedFields['email'] =
                                                  _tempValues[field]!;
                                              break;
                                            case 'phone':
                                              updatedFields['phone'] =
                                                  _tempValues[field]!;
                                              break;
                                            case 'address':
                                              updatedFields['address'] =
                                                  _tempValues[field]!;
                                              break;
                                          }
                                        }
                                      });

                                      context
                                          .read<UserProvider>()
                                          .updateUserProfile(
                                            context,
                                            full_name:
                                                updatedFields['full_name'],
                                            email: updatedFields['email'],
                                            phone: updatedFields['phone'],
                                            address: updatedFields['address'],
                                          )
                                          .then((_) {
                                        final userProvider =
                                            context.read<UserProvider>();

                                        if (userProvider.error == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Cập nhật thông tin thành công'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          setState(() {
                                            _editingFields.updateAll(
                                                (key, value) => false);
                                            _tempValues.clear();
                                          });
                                        } else {
                                          // Update thất bại
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  userProvider.error ??
                                                      'Cập nhật thất bại'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      });
                                    }
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
                            onPressed: isAnyFieldEditing
                                ? null
                                : () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChangePassword()));
                                  },
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
    String? _validateInput(String? value) {
      if (value == null || value.isEmpty) {
        return 'Không được để trống';
      }

      if (label == "SĐT:") {
        // Phone number validation
        // Must start with 0, exactly 10 digits
        if (!RegExp(r'^0\d{9}$').hasMatch(value)) {
          return 'Số điện thoại phải bắt đầu bằng 0 và có đúng 10 chữ số';
        }
      } else if (label == "Email:") {
        // Email validation
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Email không đúng định dạng';
        }
      }
    }

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
              validator: _validateInput,
              maxLength: field == "phone" ? 10 : 100,
              keyboardType:
                  field == "phone" ? TextInputType.phone : TextInputType.text,
              inputFormatters: field == "phone"
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
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
              onPressed: () => isEditing
                  ? {cancelUpdate = true, _toggleEdit(field)}
                  : _toggleEdit(field!),
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
