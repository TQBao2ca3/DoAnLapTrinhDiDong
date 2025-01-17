import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Product_Order_Page.dart';

class ItemOrder extends StatelessWidget {
  final OrderDetail orderDetails;
  final VoidCallback? onOrderStatusUpdated;

  const ItemOrder({
    Key? key,
    required this.orderDetails,
    this.onOrderStatusUpdated,
  }) : super(key: key);

  // Hàm định dạng tiền tệ
  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(amount);
  }

  // Phương thức cập nhật trạng thái đơn hàng
  Future<void> _updateOrderStatus(BuildContext context) async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://192.168.250.252:3000/api/orders/update-status/${orderDetails.orderId}'),
        headers: {'Content-Type': 'application/json'},
        body:
            json.encode({'status': 2}), // Cập nhật sang trạng thái Đã giao (2)
      );

      if (response.statusCode == 200) {
        if (context.mounted) {
          // Hiển thị thông báo thành công
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã xác nhận nhận hàng thành công'),
              backgroundColor: Colors.green,
            ),
          );

          // Gọi callback để làm mới danh sách đơn hàng
          if (onOrderStatusUpdated != null) {
            onOrderStatusUpdated!();
          }
        }
      } else {
        if (context.mounted) {
          // Hiển thị thông báo lỗi nếu không thể cập nhật
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không thể cập nhật trạng thái đơn hàng'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        // Hiển thị thông báo lỗi kết nối
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi kết nối: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Phương thức lấy nhãn trạng thái đơn hàng
  String _getOrderStatusLabel(int status) {
    switch (status) {
      case 0:
        return 'Chờ duyệt';
      case 1:
        return 'Đang giao';
      case 2:
        return 'Đã giao';
      case 3:
        return 'Đã hủy';
      default:
        return 'Trạng thái không xác định';
    }
  }

  // Phương thức lấy màu của trạng thái đơn hàng
  Color _getOrderStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
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
            // Hiển thị trạng thái đơn hàng
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    _getOrderStatusLabel(orderDetails.status),
                    style: TextStyle(
                      color: _getOrderStatusColor(orderDetails.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Chi tiết sản phẩm
            Row(
              children: [
                // Hình ảnh sản phẩm
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

                // Thông tin sản phẩm
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderDetails.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
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
                            fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ],
            ),

            // Nút xác nhận đơn hàng chỉ hiển thị khi đang ở trạng thái Đang giao (1)
            if (orderDetails.status == 1) ...[
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
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _updateOrderStatus(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          "Đã nhận được hàng",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
