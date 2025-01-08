import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phoneshop/pages/PaymentMethodPage.dart';
import 'package:phoneshop/models/CartItem.dart';

class OrderSummaryPage extends StatefulWidget {
  final int totalAmount;  // Change from double to int
  final List<CartItem>? cartItems;
  final String? paymentMethod;

  const OrderSummaryPage({
    Key? key,
    required this.totalAmount,
    this.cartItems,
    this.paymentMethod = "Thanh toán khi nhận hàng",
  }) : super(key: key);

  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  List<String> tabs = ["Chờ xác nhận", "Chờ lấy hàng", "Chờ giao hàng", "Trả hàng"];
  int selectedTabIndex = 0;
  String? currentPaymentMethod;

  String formatCurrency(int amount) {
    final formatCurrency = NumberFormat('#,##0 đ', 'vi_VN');
    return formatCurrency.format(amount);
  }

  @override
  void initState() {
    super.initState();
    currentPaymentMethod = widget.paymentMethod;
  }

  void _openPaymentMethodPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentMethodPage()),
    );

    if (result != null) {
      setState(() {
        currentPaymentMethod = result;
      });
    }
  }

  Widget _buildProductItem(CartItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              item.image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
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
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Màu: ${item.color}",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatCurrency(item.price),
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (item.price != item.originalPrice)
                            Text(
                              formatCurrency(item.originalPrice),
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      Text("x${item.quantity}"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn đã mua'),
      ),
      body: Column(
        children: [
          // Tab bar
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedTabIndex = index;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedTabIndex == index ? Colors.red : Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          color: selectedTabIndex == index ? Colors.red : Colors.black87,
                          fontSize: 14,
                          fontWeight: selectedTabIndex == index ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Order content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Store info
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(Icons.storefront, color: Colors.red),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Phone Shop",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Text(
                              "Chờ thanh toán",
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ],
                        ),
                        const Divider(),
                        if (widget.cartItems != null && widget.cartItems!.isNotEmpty)
                          _buildProductItem(widget.cartItems!.first),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Tổng số tiền (1 sản phẩm):"),
                            Text(
                              formatCurrency(widget.totalAmount),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Payment section
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text("Thanh toán trong "),
                            Text(
                              "23:59:04",
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                            Text(" bằng $currentPaymentMethod"),
                            const Spacer(),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: _openPaymentMethodPage,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            side: const BorderSide(color: Colors.grey),
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            "Đổi phương thức thanh toán",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}