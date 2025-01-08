import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thêm import này để sử dụng NumberFormat


class ShippingMethodPage extends StatelessWidget {
  final String selectedMethod;

  const ShippingMethodPage({super.key, required this.selectedMethod});

  // Hàm định dạng tiền tệ
  String _formatCurrency(double amount) {
    final formatCurrency = NumberFormat('#,##0 đ', 'vi_VN');
    return formatCurrency.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final shippingMethods = [
      {
        'name': 'Giao hàng tiêu chuẩn',
        'time': '3-5 ngày',
        'price': 32800.0,
        'icon': Icons.local_shipping,
      },
      {
        'name': 'Giao hàng nhanh',
        'time': '1-2 ngày',
        'price': 48000.0,
        'icon': Icons.directions_bike,
      },
      {
        'name': 'Giao hàng hỏa tốc',
        'time': 'Trong ngày',
        'price': 98000.0,
        'icon': Icons.electric_bike,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phương thức vận chuyển'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        itemCount: shippingMethods.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final method = shippingMethods[index];
          return ListTile(
            leading: Icon(method['icon'] as IconData),
            title: Text(method['name'] as String),
            subtitle: Text('Thời gian: ${method['time']}'),
            trailing: Text(
              _formatCurrency(method['price'] as double), // Sử dụng hàm định dạng tiền tệ
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context, method['name'] as String);
            },
          );
        },
      ),
    );
  }
}
