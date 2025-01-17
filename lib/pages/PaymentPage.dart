import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phoneshop/models/Address.dart';
import 'package:phoneshop/models/CartItem.dart';
import 'package:phoneshop/pages/AddressListPage%20.dart';
import 'package:phoneshop/pages/PaymentMethodPage.dart';
import 'package:phoneshop/pages/PaymentWaitingPage%20.dart';
import 'package:phoneshop/pages/ShippingMethodPage%20.dart';

class PaymentPage extends StatefulWidget {
  final List<dynamic>
      cartItems; // Thay thế dynamic bằng kiểu dữ liệu thực tế của item trong giỏ hàng
  final int totalAmount;

  const PaymentPage({
    Key? key,
    required this.cartItems,
    required this.totalAmount,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Address? selectedAddress;
  List<Address> addresses = [];
  String? selectedShippingMethod = "Nhanh";
  String? selectedPaymentMethod = "Thẻ nội địa Napas";
  int shippingFee = 42500;
  int voucherDiscount = 0;

  String _formatCurrency(int amount) {
    final formatCurrency = NumberFormat('#,##0 đ', 'vi_VN');
    return formatCurrency.format(amount);
  }

  @override
  void initState() {
    super.initState();
    // Khởi tạo danh sách địa chỉ mẫu
    addresses = [
      Address(
        name: "Trần Quốc Bảo",
        phone: "(+84) 766 926 067",
        address: "Số nhà 103 tổ 5 ấp AB\nXã Mỹ Hội, Huyện Cao Lãnh, Đồng Tháp",
        isDefault: true,
      ),
      Address(
        name: "Trần Quốc Bảo",
        phone: "(+84) 766 926 067",
        address: "663 Trần Xuân Soan\nPhường Tân Hưng, Quận 7, TP. Hồ Chí Minh",
        isDefault: false,
      ),
    ];
    selectedAddress = addresses.firstWhere((addr) => addr.isDefault,
        orElse: () => addresses.first);
  }

// Trong class _PaymentPageState thêm các phương thức sau:
  void _openShippingMethodPage() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const ShippingMethodPage(
          selectedMethod:
              'Express Shipping', // Truyền giá trị cho selectedMethod
        ),
      ),
    );

    if (result != null) {
      setState(() {
        selectedShippingMethod = result;
      });
    }
  }

  void _openPaymentMethodPage() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodPage(
          selectedMethod: selectedPaymentMethod,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        selectedPaymentMethod = result;
      });
    }
  }

  void _openAddressSelection() async {
    final result = await Navigator.push<Address>(
      // Chỉ định kiểu rõ ràng là Address
      context,
      MaterialPageRoute(
        builder: (context) => AddressListPage(
          addresses: addresses,
          selectedAddress: selectedAddress,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        selectedAddress = result;
        // Cập nhật địa chỉ trong danh sách nếu là địa chỉ mới
        int index = addresses.indexWhere((addr) =>
            addr.phone == result.phone && addr.address == result.address);
        if (index == -1) {
          // Nếu là địa chỉ mới, thêm vào danh sách
          if (result.isDefault) {
            // Nếu địa chỉ mới là mặc định, bỏ mặc định của các địa chỉ khác
            for (var addr in addresses) {
              addr.isDefault = false;
            }
          }
          addresses.add(result);
        } else {
          // Nếu địa chỉ đã tồn tại, cập nhật nó
          addresses[index] = result;
          if (result.isDefault) {
            for (var i = 0; i < addresses.length; i++) {
              if (i != index) {
                addresses[i].isDefault = false;
              }
            }
          }
        }
      });
    }
  }

  Widget _buildAddressSection() {
    if (selectedAddress == null) {
      return ListTile(
        leading: const Icon(Icons.location_on, color: Colors.red),
        title: const Text("Chọn địa chỉ giao hàng"),
        trailing: const Icon(Icons.chevron_right),
        onTap: _openAddressSelection,
      );
    }

    return InkWell(
      onTap: _openAddressSelection,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_on, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        selectedAddress!.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        selectedAddress!.phone,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedAddress!.address,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(CartItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.storeName != null) ...[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child:
                      const Icon(Icons.storefront, color: Colors.red, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  item.storeName!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                item.image_url,
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
                      item.description,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Màu: ${item.colors}, ${item.storage}",
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
                              "đ${item.price}",
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (item.price != item.price)
                              Text(
                                "đ${item.price}",
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar với thiết kế mới
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Thanh toán',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Địa chỉ đã chọn với thiết kế mới
                    Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: _buildAddressSection(),
                    ),

                    // Danh sách sản phẩm
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: widget.cartItems
                            .map((item) => _buildProductItem(item))
                            .toList(),
                      ),
                    ),

                    // Voucher của Shop
                    Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: const Text(
                          'Voucher của Shop',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Chọn hoặc nhập mã',
                              style: TextStyle(color: Colors.blue[600]),
                            ),
                            Icon(Icons.chevron_right, color: Colors.blue[600]),
                          ],
                        ),
                        onTap: () {
                          // TODO: Implement voucher selection
                        },
                      ),
                    ),

                    // Phương thức vận chuyển
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: const Text(
                          "Phương thức vận chuyển",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.check,
                                          color: Colors.blue[700], size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Nhanh",
                                        style: TextStyle(
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "đ${shippingFee.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Miễn Phí",
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Nhận hàng vào ${DateTime.now().day + 3} Tháng ${DateTime.now().month}",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        trailing:
                            Icon(Icons.chevron_right, color: Colors.blue[600]),
                        onTap: _openShippingMethodPage,
                      ),
                    ),

                    // Phương thức thanh toán
                    Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Phương thức thanh toán",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Xem tất cả",
                                  style: TextStyle(color: Colors.blue[600]),
                                ),
                              ],
                            ),
                            onTap: _openPaymentMethodPage,
                          ),
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                selectedPaymentMethod ==
                                        "Thanh toán khi nhận hàng"
                                    ? Icons.local_shipping
                                    : Icons.credit_card,
                                color: Colors.blue[700],
                              ),
                            ),
                            title: Text(
                              selectedPaymentMethod ?? "",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              selectedPaymentMethod ==
                                      "Thanh toán khi nhận hàng"
                                  ? "Thanh toán khi nhận được hàng"
                                  : "Thêm thẻ ngân hàng của bạn",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: Icon(Icons.chevron_right,
                                color: Colors.blue[600]),
                            onTap: _openPaymentMethodPage,
                          ),
                        ],
                      ),
                    ),

                    // Chi tiết thanh toán
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Chi tiết thanh toán",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tổng tiền hàng",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                _formatCurrency(widget.totalAmount),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Phí vận chuyển",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Row(
                                children: [
                                  Text(
                                    _formatCurrency(shippingFee),
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Miễn phí",
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Tổng thanh toán",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _formatCurrency(widget.totalAmount),
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Tiết kiệm ${_formatCurrency(shippingFee)}",
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
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
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tổng thanh toán",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatCurrency(widget.totalAmount),
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentWaitingPage(
                        totalAmount: widget.totalAmount,
                        cartItems: List<CartItem>.from(widget.cartItems),
                        paymentMethod:
                            selectedPaymentMethod ?? "Thẻ nội địa Napas",
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Đặt hàng",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
