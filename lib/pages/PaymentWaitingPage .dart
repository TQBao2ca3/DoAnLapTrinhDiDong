import 'package:flutter/material.dart';
import 'package:phoneshop/models/Cart.dart';
import 'package:phoneshop/models/CartItem.dart';
import 'package:phoneshop/pages/Homepage.dart';
import 'package:phoneshop/pages/OrderSummaryPage.dart';
import 'package:phoneshop/pages/PaymentMethodPage.dart';

class PaymentWaitingPage extends StatefulWidget {
  final int totalAmount;
  final List<CartItem> cartItems;
  final String paymentMethod;

  const PaymentWaitingPage({
    Key? key,
    required this.totalAmount,
    required this.cartItems,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  State<PaymentWaitingPage> createState() => _PaymentWaitingPageState();
}

class _PaymentWaitingPageState extends State<PaymentWaitingPage> {
  @override
  void initState() {
    super.initState();
    // Debug prints để kiểm tra dữ liệu
    print('PaymentWaitingPage - Initial Cart Items: ${widget.cartItems.length}');
    for (var item in widget.cartItems) {
      print('Item Debug - Name: ${item.name}, Price: ${item.price}, Color: ${item.color}, Quantity: ${item.quantity}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug prints trong build
    print('PaymentWaitingPage Build - Cart Items Count: ${widget.cartItems.length}');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back ,
            size: 30,
            color: Color(0xFF4C53A5),),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF0000FF),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Đang chờ thanh toán',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Vui lòng thanh toán đ${widget.totalAmount.toStringAsFixed(0)} trước 05-01-2025 10:09. Thường xuyên kiểm tra tin nhắn từ Người bán tại Shopee Chat / Chỉ nhận & thanh toán khi đơn mua ở trạng thái "Đang giao hàng".',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(cart: Cart()),
                        ),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.cyan),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Trang chủ',
                      style: TextStyle(
                        color:Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Debug print trước khi navigate
                      print('Navigating to OrderSummaryPage with ${widget.cartItems.length} items');
                      for (var item in widget.cartItems) {
                        print('Sending item: ${item.name}');
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderSummaryPage(
                            totalAmount: widget.totalAmount,
                            cartItems: List<CartItem>.from(widget.cartItems), // Tạo một bản sao của danh sách
                            paymentMethod: widget.paymentMethod,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.cyan),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Đơn mua',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // Debug widget để hiển thị số lượng sản phẩm
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Debug: Số lượng sản phẩm: ${widget.cartItems.length}',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}