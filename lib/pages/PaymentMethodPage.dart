import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentMethod {
  final String name;
  final String? subtitle;
  final String? description;
  final IconData icon;
  final bool isEnabled;
  final String? actionButton;

  PaymentMethod({
    required this.name,
    this.subtitle,
    this.description,
    required this.icon,
    this.isEnabled = true,
    this.actionButton,
  });
}

class PaymentMethodPage extends StatefulWidget {
  final String? selectedMethod;

  const PaymentMethodPage({Key? key, this.selectedMethod}) : super(key: key);

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  String? selectedMethod;
  final List<PaymentMethod> methods = [
    PaymentMethod(
      name: "Thẻ Tín dụng/Ghi nợ",
      icon: Icons.credit_card,
      subtitle: "Hỗ trợ Visa, Mastercard, JCB",
      description: "Thanh toán bằng thẻ tín dụng hoặc ghi nợ quốc tế.",
    ),
    PaymentMethod(
      name: "Google Pay",
      icon: Icons.g_mobiledata,
      subtitle: "Thanh toán tiện lợi qua Google Pay",
      description: "Dễ dàng liên kết với tài khoản ngân hàng của bạn.",
    ),
    PaymentMethod(
      name: "Thanh toán khi nhận hàng",
      icon: Icons.local_shipping,
      isEnabled: true,
      description: "Chỉ áp dụng cho đơn hàng dưới 5 triệu đồng.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedMethod = widget.selectedMethod ?? "Thanh toán khi nhận hàng";
  }

  // Method to format currency
  String _formatCurrency(double amount) {
    final formatCurrency = NumberFormat('#,##0 đ', 'vi_VN');
    return formatCurrency.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Phương thức thanh toán",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlue,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Color(0xFF4C53A5),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.security, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'PHONE SHOP ĐẢM BẢO',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: methods.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final method = methods[index];
                final isSelected = method.name == selectedMethod;

                return ListTile(
                  enabled: method.isEnabled,
                  contentPadding: const EdgeInsets.all(16),
                  leading: Icon(
                    method.icon,
                    color: method.isEnabled ? Colors.lightBlue : Colors.grey,
                    size: 24,
                  ),
                  title: Text(
                    method.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: method.isEnabled ? Colors.black : Colors.grey,
                    ),
                  ),
                  subtitle: method.subtitle != null || method.description != null
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (method.subtitle != null)
                        Text(method.subtitle!),
                      if (method.description != null)
                        Text(
                          method.description!,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                    ],
                  )
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (method.actionButton != null)
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: Text(method.actionButton!),
                        ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check_circle, color: Colors.red),
                      ],
                    ],
                  ),
                  onTap: method.isEnabled
                      ? () {
                    setState(() {
                      selectedMethod = method.name;
                    });
                  }
                      : null,
                );
              },
            ),
          ),
        ],
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
        child: ElevatedButton(
          onPressed: () {
            // Example usage of the _formatCurrency function with some amount
            double amount = 1000000; // Example amount
            print("Formatted amount: ${_formatCurrency(amount)}");

            Navigator.pop(context, selectedMethod);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text(
            'ĐỒNG Ý',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
