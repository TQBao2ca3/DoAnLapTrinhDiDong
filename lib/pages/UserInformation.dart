import 'package:flutter/material.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final _formKey = GlobalKey<FormState>();

  // Theo dõi trạng thái edit của từng trường
  final Map<String, bool> _editingFields = {
    'name': false,
    'email': false,
    'phone': false,
    'address': false,
  };

  // Data
  final Map<String, String> _userData = {
    'username': 'user1234',
    'name': 'name',
    'email': 'email',
    'phone': '0423145136',
    'address': 'HCMC',
  };

  // Temporary values while editing
  final Map<String, String> _tempValues = {};

  void _toggleEdit(String field) {
    setState(() {
      if (_editingFields[field]!) {
        // Nếu đang edit thì lưu giá trị
        _userData[field] = _tempValues[field] ?? _userData[field]!;
      } else {
        // Bắt đầu edit thì lưu giá trị tạm
        _tempValues[field] = _userData[field]!;
      }
      _editingFields[field] = !_editingFields[field]!;
    });
  }

  bool get isAnyFieldEditing => _editingFields.values.any((editing) => editing);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: Text(
          isAnyFieldEditing ? 'Thông tin user đang sửa' : 'Thông tin user',
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                  _buildInfoField(
                    label: 'Họ và tên:',
                    field: 'name',
                    value: _userData['name']!,
                  ),
                  _buildInfoField(
                    label: 'Email:',
                    field: 'email',
                    value: _userData['email']!,
                  ),
                  _buildInfoField(
                    label: 'SĐT:',
                    field: 'phone',
                    value: _userData['phone']!,
                  ),
                  _buildInfoField(
                    label: 'Địa chỉ:',
                    field: 'address',
                    value: _userData['address']!,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: isAnyFieldEditing
                        ? () {
                            // Lưu tất cả các thay đổi
                            setState(() {
                              _editingFields.forEach((field, editing) {
                                if (editing) {
                                  _userData[field] =
                                      _tempValues[field] ?? _userData[field]!;
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
                    child: Text('Cập nhật thông tin'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: !isAnyFieldEditing
                        ? () {
                            // Xử lý đổi mật khẩu
                          }
                        : null,
                    child: Text(
                      'Đổi mật khẩu',
                      style: TextStyle(
                        color: !isAnyFieldEditing ? Colors.red : Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
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
