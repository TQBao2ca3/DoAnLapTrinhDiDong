// order_details_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phoneshop/models/CartItem.dart';

class OrderDetailsPage extends StatelessWidget {
  final CartItem item;
  final String orderId;
  final DateTime orderTime;

  const OrderDetailsPage({
    Key? key,
    required this.item,
    required this.orderId,
    required this.orderTime,
  }) : super(key: key);

  String formatCurrency(int amount) {
    final formatCurrency = NumberFormat('#,##0 đ', 'vi_VN');
    return formatCurrency.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
            size: 30,
            color: Color(0xFF4C53A5),),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thông tin đơn hàng',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlue,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address Section
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Địa chỉ nhận hàng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Trần Quốc Bảo',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Text('(+84) 766 926 067'),
                            const Text(
                              'Số nhà 103 tổ 5 ấp AB, Xã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Cập nhật'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Store and Product Section
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const Text(
                          "Mall",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.storeName ?? "SamCenter Official Store",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset(
                          item.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(fontSize: 14),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.color,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatCurrency(item.price),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('x${item.quantity}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Order Info Section
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Mã đơn hàng'),
                      Row(
                        children: [
                          Text(orderId),
                          IconButton(
                            icon: const Text(
                              'SAO CHÉP',
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Thời gian đặt hàng'),
                      Text(
                        DateFormat('dd-MM-yyyy HH:mm').format(orderTime),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Support Section
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bạn cần hỗ trợ?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.chat_bubble_outline),
                    title: const Text('Liên hệ Shop'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Trung tâm Hỗ trợ'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              side: BorderSide(color: Colors.grey.shade300),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Hủy đơn hàng',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}