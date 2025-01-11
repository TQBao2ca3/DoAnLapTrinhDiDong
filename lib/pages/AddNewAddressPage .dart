import 'package:flutter/material.dart';
import 'package:phoneshop/models/Address.dart';

class AddNewAddressPage extends StatefulWidget {
  const AddNewAddressPage({Key? key}) : super(key: key);

  @override
  _AddNewAddressPageState createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  bool _isDefault = false;
  String _addressType = 'Nhà Riêng';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Địa chỉ mới'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Liên hệ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Họ và tên',
                filled: true,
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Vui lòng nhập họ tên';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                hintText: 'Số điện thoại',
                filled: true,
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Vui lòng nhập số điện thoại';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Địa chỉ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(
                hintText: 'Tỉnh/Thành phố, Quận/Huyện, Phường/Xã',
                filled: true,
                border: InputBorder.none,
                suffixIcon: Icon(Icons.chevron_right),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Vui lòng chọn địa chỉ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _streetController,
              decoration: const InputDecoration(
                hintText: 'Tên đường, Tòa nhà, Số nhà.',
                filled: true,
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Vui lòng nhập địa chỉ chi tiết';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Cài đặt',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Loại địa chỉ:'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildAddressTypeChip('Văn Phòng'),
                      const SizedBox(width: 8),
                      _buildAddressTypeChip('Nhà Riêng'),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Đặt làm địa chỉ mặc định',style: TextStyle(fontSize: 14,color: Colors.black),),
                  Switch(
                    value: _isDefault,
                    onChanged: (value) {
                      setState(() {
                        _isDefault = value;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                final newAddress = Address(
                  name: _nameController.text,
                  phone: _phoneController.text,
                  address: '${_streetController.text}\n${_cityController.text}',
                  isDefault: _isDefault,
                  addressType: _addressType,
                );
                Navigator.pop(context, newAddress);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text(
              'HOÀN THÀNH',
              style: TextStyle(fontSize: 16,color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressTypeChip(String type) {
    return ChoiceChip(
      label: Text(type),
      selected: _addressType == type,
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            _addressType = type;
          });
        }
      },
      selectedColor: Colors.red.shade50,
      labelStyle: TextStyle(
        color: _addressType == type ? Colors.red : Colors.black,
      ),
    );
  }
}