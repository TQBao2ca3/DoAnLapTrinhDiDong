import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Product_Order_Page.dart';

class ItemOrder extends StatelessWidget {
  final OrderDetail orderDetails;

  const ItemOrder({
    Key? key,
    required this.orderDetails
  }) : super(key: key);

  // Hàm format tiền tệ
  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    orderDetails.imageUrl,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        width: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderDetails.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Dung lượng: ${orderDetails.storage}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Số lượng: ${orderDetails.quantity}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _formatCurrency(orderDetails.price),
                          style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Tổng tiền: ${_formatCurrency(orderDetails.total)}',
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        )
                      ],
                    )
                )
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bạn hài lòng với sản phẩm đã nhận? Nếu có, chọn \"Xác nhận\"",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Xử lý khi nhấn nút xác nhận đơn hàng
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                      child: const Text(
                        "Đã nhận được hàng",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}