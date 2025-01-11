import 'package:flutter/material.dart';
import 'package:phoneshop/pages/OrderDetailsPage.dart';
import 'package:phoneshop/pages/PaymentMethodPage.dart';
import 'package:phoneshop/models/CartItem.dart';
import 'package:intl/intl.dart';
class OrderSummaryPage extends StatefulWidget {
  final int totalAmount;
  final List<CartItem> cartItems;
  final String? paymentMethod;

  const OrderSummaryPage({
    Key? key,
    required this.totalAmount,
    required this.cartItems,
    this.paymentMethod = "Thẻ nội địa Napas",
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
    return InkWell( // Changed from GestureDetector to InkWell for better touch feedback
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsPage(
              item: item,
              orderId: '250104K63J7E16',
              orderTime: DateTime(2025, 1, 4, 10, 9),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                const Spacer(),
                Text(
                  "Chờ thanh toán",
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Product details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    item.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // Product info
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
                        item.color,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("x${item.quantity}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (item.price != item.originalPrice)
                            Text(
                              "${formatCurrency(item.originalPrice)}",
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          Text(
                            "${formatCurrency(item.price)}",
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
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
    );
  }

  Widget _buildOrderContent() {
    if (selectedTabIndex == 0 && widget.cartItems.isNotEmpty) {
      return Column(
        children: [
          const SizedBox(height: 8),
          ...widget.cartItems.map((item) => _buildProductItem(item)).toList(),
          const SizedBox(height: 8),

          // Total amount
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tổng số tiền (${widget.cartItems.length} sản phẩm):",
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  "${formatCurrency(widget.totalAmount)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Payment section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                InkWell(
                  onTap: _openPaymentMethodPage,
                  child: Row(
                    children: [
                      const Text("Thanh toán"),
                      Text(" bằng $currentPaymentMethod"),
                      const Spacer(),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _openPaymentMethodPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Đổi phương thức thanh toán",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // Empty state for different tabs
      IconData icon;
      String message;

      switch (selectedTabIndex) {
        case 0:
          icon = Icons.hourglass_empty;
          message = "Không có đơn hàng nào đang chờ xác nhận";
          break;
        case 1:
          icon = Icons.local_shipping_outlined;
          message = "Không có đơn hàng nào đang chờ lấy hàng";
          break;
        case 2:
          icon = Icons.delivery_dining_outlined;
          message = "Không có đơn hàng nào đang giao";
          break;
        case 3:
          icon = Icons.assignment_return_outlined;
          message = "Không có đơn hàng nào đã trả";
          break;
        default:
          icon = Icons.hourglass_empty;
          message = "Không có đơn hàng nào";
      }

      return Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              size: 30,
              color: Color(0xFF4C53A5)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Đơn đã mua',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlue,
          ),
        ),
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

          // Content area
          Expanded(
            child: SingleChildScrollView(
              child: _buildOrderContent(),
            ),
          ),
        ],
      ),
    );
  }
}