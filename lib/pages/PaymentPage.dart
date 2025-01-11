  import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phoneshop/models/Address.dart';
  import 'package:phoneshop/models/CartItem.dart';
import 'package:phoneshop/pages/AddressListPage%20.dart';
import 'package:phoneshop/pages/PaymentMethodPage.dart';
  import 'package:phoneshop/pages/PaymentWaitingPage%20.dart';
  import 'package:phoneshop/pages/ShippingMethodPage%20.dart';

  class PaymentPage extends StatefulWidget {
    final List<dynamic> cartItems;  // Thay thế dynamic bằng kiểu dữ liệu thực tế của item trong giỏ hàng
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
      selectedAddress = addresses.firstWhere((addr) => addr.isDefault, orElse: () => addresses.first);
    }
// Trong class _PaymentPageState thêm các phương thức sau:
    void _openShippingMethodPage() async {
      final result = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) =>  ShippingMethodPage(
            selectedMethod: 'Express Shipping', // Truyền giá trị cho selectedMethod
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
      final result = await Navigator.push<Address>( // Chỉ định kiểu rõ ràng là Address
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
          addr.phone == result.phone && addr.address == result.address
          );
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
                    child: const Icon(Icons.storefront, color: Colors.red, size: 20),
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
                        "Màu: ${item.color},",
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
                                "đ${item.price.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (item.price != item.originalPrice)
                                Text(
                                  "đ${item.originalPrice.toStringAsFixed(0)}",
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
        appBar: AppBar(
          title: const Text("Thanh toán", style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlue,
          ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
              size: 30,
              color: Color(0xFF4C53A5),),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Địa chỉ đã chọn
              _buildAddressSection(),
              const Divider(height: 8, thickness: 8),

              // Danh sách sản phẩm
              ...widget.cartItems.map((item) => _buildProductItem(item)).toList(),

              // Voucher của Shop
              ListTile(
                tileColor: Colors.white,
                title: const Text('Voucher của Shop'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Chọn hoặc nhập mã'),
                    Icon(Icons.chevron_right),
                  ],
                ),
                onTap: () {
                  // TODO: Implement voucher selection
                },
              ),

              // Cập nhật phần shipping method trong build:
              Container(
                color: Colors.white,
                child: ListTile(
                  title: const Text("Phương thức vận chuyển"),
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
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.check, color: Colors.green, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  "Nhanh",
                                  style: TextStyle(color: Colors.green),
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
                          const Text(
                            "Miễn Phí",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Nhận hàng vào 18 Tháng 1",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _openShippingMethodPage,
                ),
              ),

              const Divider(height: 8, thickness: 8),

              // Cập nhật phần payment method:
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Phương thức thanh toán"),
                          Text("Xem tất cả >",
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                      onTap: _openPaymentMethodPage,
                    ),
                    ListTile(
                      leading: selectedPaymentMethod == "Thanh toán khi nhận hàng"
                          ? const Icon(Icons.local_shipping, color: Colors.red)
                          : const Icon(Icons.credit_card, color: Colors.blue),
                      title: Text(selectedPaymentMethod ?? ""),
                      subtitle: selectedPaymentMethod == "Thanh toán khi nhận hàng"
                          ? const Text("Thanh toán khi nhận được hàng")
                          : const Text("Thêm thẻ ngân hàng của bạn"),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _openPaymentMethodPage,
                    ),
                  ],
                ),
              ),
              const Divider(height: 8, thickness: 8),

              // Chi tiết thanh toán
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Tổng số tiền sản phẩm: "),
                        Text(
                          _formatCurrency(widget.totalAmount),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Phí vận chuyển"),
                        Text(
                          _formatCurrency(shippingFee),
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Tổng thanh toán",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _formatCurrency(widget.totalAmount),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Tiết kiệm ${_formatCurrency(shippingFee)}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
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
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tổng thanh toán: ${_formatCurrency(widget.totalAmount)}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Tiết kiệm ${_formatCurrency(shippingFee)}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // Trong PaymentPage khi chuyển sang PaymentWaitingPage
                  // Trong PaymentPage khi chuyển sang PaymentWaitingPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentWaitingPage(
                        totalAmount: widget.totalAmount, // Sử dụng widget.totalAmount thay vì totalAmount
                        cartItems: List<CartItem>.from(widget.cartItems),
                        paymentMethod: selectedPaymentMethod ?? "Thẻ nội địa Napas",
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  "Đặt hàng",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

  }