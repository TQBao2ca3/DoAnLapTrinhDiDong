import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartBottomNavBar extends StatelessWidget {
  final double totalAmount;

  const CartBottomNavBar({super.key, required this.totalAmount});

  String _formatCurrency(double amount) {
    final formatCurrency = NumberFormat('#,##0 đ', 'vi_VN');
    return formatCurrency.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue[100],
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom: MediaQuery.of(context).padding.bottom +
              10, // Thêm padding cho notch
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Tổng tiền: ${_formatCurrency(totalAmount)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => _showPaymentDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Thanh toán",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Thanh toán"),
          content: const Text("Bạn có chắc chắn muốn thanh toán không?"),
          actions: [
            TextButton(
              child: const Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Thanh toán"),
              onPressed: () {
                Navigator.of(context).pop();
                // Xử lý thanh toán ở đây
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Thanh toán thành công!"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
