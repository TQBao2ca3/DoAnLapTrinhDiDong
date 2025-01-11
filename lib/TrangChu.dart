import 'package:flutter/material.dart';
import 'main.dart';

class Order {
  final String id;
  final String customerName;
  final String phone;
  final List<OrderProduct> products;
  final double total;
  final String status;
  final String date;

  Order({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.products,
    required this.total,
    required this.status,
    required this.date,
  });
}

class OrderProduct {
  final String name;
  final int quantity;
  final double price;

  OrderProduct({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  String selectedStatus = 'all';
  final searchController = TextEditingController();
  final mainBlue = const Color(0xFF0066CC);

  // Dữ liệu mẫu
  List<Order> orders = [
    Order(
      id: 'ORD001',
      customerName: 'Nguyễn Văn A',
      phone: '0123456789',
      products: [
        OrderProduct(name: 'iPhone 13', quantity: 1, price: 20000000),
        OrderProduct(name: 'Ốp lưng iPhone', quantity: 2, price: 200000),
      ],
      total: 20400000,
      status: 'pending',
      date: '2024-01-04',
    ),
    Order(
      id: 'ORD002',
      customerName: 'Trần Thị B',
      phone: '0987654321',
      products: [
        OrderProduct(name: 'Samsung S21', quantity: 1, price: 18000000),
      ],
      total: 18000000,
      status: 'completed',
      date: '2024-01-04',
    ),
  ];

  void updateOrderStatus(String orderId, String newStatus) {
    setState(() {
      orders = orders.map((order) {
        if (order.id == orderId) {
          return Order(
            id: order.id,
            customerName: order.customerName,
            phone: order.phone,
            products: order.products,
            total: order.total,
            status: newStatus,
            date: order.date,
          );
        }
        return order;
      }).toList();
    });
  }

  void updateProductQuantity(String orderId, String productName, int newQuantity) {
    setState(() {
      orders = orders.map((order) {
        if (order.id == orderId) {
          final updatedProducts = order.products.map((product) {
            if (product.name == productName) {
              return OrderProduct(
                name: product.name,
                quantity: newQuantity,
                price: product.price,
              );
            }
            return product;
          }).toList();

          final newTotal = updatedProducts.fold<double>(
            0,
                (sum, product) => sum + (product.price * product.quantity),
          );

          return Order(
            id: order.id,
            customerName: order.customerName,
            phone: order.phone,
            products: updatedProducts,
            total: newTotal,
            status: order.status,
            date: order.date,
          );
        }
        return order;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = selectedStatus == 'all'
        ? orders
        : orders.where((order) => order.status == selectedStatus).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: mainBlue,
        elevation: 0,
        title: const Text(
          'Quản lý đơn hàng',
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(100, 70, 0, 0),  // Điều chỉnh vị trí menu
                items: [
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.admin_panel_settings),
                      title: Text('Thông tin Admin'),
                      onTap: () {
                        Navigator.pop(context); // Đóng menu
                        // Hiện dialog thông tin admin
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // Controllers cho việc edit thông tin
                            TextEditingController nameController = TextEditingController(text: "Admin");
                            TextEditingController emailController = TextEditingController(text: "admin@gmail.com");
                            TextEditingController phoneController = TextEditingController(text: "0123456789");

                            return AlertDialog(
                              title: Text('Thông tin Admin'),
                              content: Container(
                                height: 250,
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        labelText: 'Họ tên',
                                        icon: Icon(Icons.person),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    TextField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        icon: Icon(Icons.email),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    TextField(
                                      controller: phoneController,
                                      decoration: InputDecoration(
                                        labelText: 'Số điện thoại',
                                        icon: Icon(Icons.phone),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Đóng dialog
                                  },
                                  child: Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // TODO: Xử lý cập nhật thông tin
                                    Navigator.of(context).pop(); // Đóng dialog
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Cập nhật thông tin thành công!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  child: Text('Lưu'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Đăng xuất'),
                      onTap: () {
                        Navigator.pop(context); // Đóng menu
                        // Hiện dialog xác nhận đăng xuất
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Xác nhận'),
                              content: Text('Bạn có chắc chắn muốn đăng xuất?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Đóng dialog
                                  },
                                  child: Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Đóng dialog
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginPage()),
                                    );
                                  },
                                  child: Text('Đăng xuất',style: TextStyle(color: Colors.white),),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Stats Row
          Row(
            children: [
              _buildStatCard(
                icon: Icons.shopping_bag_outlined,
                title: 'Tổng đơn hàng',
                value: '256',
                color: mainBlue,
              ),
              _buildStatCard(
                icon: Icons.pending_actions_outlined,
                title: 'Chờ xử lý',
                value: '12',
                color: Colors.orange,
              ),
              _buildStatCard(
                icon: Icons.check_circle_outline,
                title: 'Hoàn thành',
                value: '189',
                color: Colors.green,
              ),
              _buildStatCard(
                icon: Icons.cancel_outlined,
                title: 'Đã hủy',
                value: '5',
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Main Content Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      const Text(
                        'Danh sách đơn hàng',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // Search
                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm đơn hàng...',
                            prefixIcon: Icon(Icons.search, color: mainBlue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: mainBlue, width: 2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Status Filter
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedStatus,
                            hint: const Text('Trạng thái'),
                            style: TextStyle(color: Colors.grey[800], fontSize: 14),
                            onChanged: (value) {
                              setState(() => selectedStatus = value!);
                            },
                            items: const [
                              DropdownMenuItem(
                                value: 'all',
                                child: Text('Tất cả trạng thái'),
                              ),
                              DropdownMenuItem(
                                value: 'pending',
                                child: Text('Chờ xử lý'),
                              ),
                              DropdownMenuItem(
                                value: 'processing',
                                child: Text('Đang xử lý'),
                              ),
                              DropdownMenuItem(
                                value: 'completed',
                                child: Text('Hoàn thành'),
                              ),
                              DropdownMenuItem(
                                value: 'cancelled',
                                child: Text('Đã hủy'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Table
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
                    dataRowHeight: 70,
                    columns: [
                      DataColumn(
                        label: Text(
                          'Mã đơn',
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Khách hàng',
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Số điện thoại',
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Tổng tiền',
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Trạng thái',
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Ngày đặt',
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ),
                      const DataColumn(label: Text('')),
                    ],
                    rows: filteredOrders.map((order) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              order.id,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          DataCell(Text(order.customerName)),
                          DataCell(Text(order.phone)),
                          DataCell(
                            Text(
                              '${order.total.toStringAsFixed(0)}đ',
                              style: TextStyle(
                                color: mainBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataCell(_buildStatusBadge(order.status)),
                          DataCell(Text(order.date)),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildActionButton(
                                  icon: Icons.edit_outlined,
                                  label: 'Cập nhật',
                                  onPressed: () => _showOrderUpdate(context, order),
                                ),
                                const SizedBox(width: 8),
                                _buildActionButton(
                                  icon: Icons.visibility_outlined,
                                  label: 'Chi tiết',
                                  onPressed: () => _showOrderDetails(context, order, false),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        text = 'Chờ xử lý';
        break;
      case 'processing':
        color = mainBlue;
        text = 'Đang xử lý';
        break;
      case 'completed':
        color = Colors.green;
        text = 'Hoàn thành';
        break;
      case 'cancelled':
        color = Colors.red;
        text = 'Đã hủy';
        break;
      default:
        color = Colors.grey;
        text = 'Không xác định';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: mainBlue,
        backgroundColor: Colors.blue[50],
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
      onPressed: onPressed,
    );
  }

  void _showOrderDetails(BuildContext context, Order order, bool canEdit) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chi tiết đơn hàng #${order.id}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cập nhật ngày ${order.date}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 32),

              // Customer Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.person_outline,
                      label: 'Khách hàng',
                      value: order.customerName,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.phone_outlined,
                      label: 'Số điện thoại',
                      value: order.phone,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Ngày đặt',
                      value: order.date,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.sync, size: 20, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Trạng thái:',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (canEdit)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: mainBlue),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: order.status,
                                onChanged: (value) {
                                  if (value != null) {
                                    updateOrderStatus(order.id, value);
                                  }
                                },
                                items: const [
                                  DropdownMenuItem(
                                    value: 'pending',
                                    child: Text('Chờ xử lý'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'processing',
                                    child: Text('Đang xử lý'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'completed',
                                    child: Text('Hoàn thành'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'cancelled',
                                    child: Text('Đã hủy'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          _buildStatusBadge(order.status),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Products Table
              const Text(
                'Danh sách sản phẩm',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
                    columns: const [
                      DataColumn(label: Text('Sản phẩm')),
                      DataColumn(label: Text('Đơn giá')),
                      DataColumn(label: Text('Số lượng')),
                      DataColumn(label: Text('Thành tiền')),
                    ],
                    rows: order.products.map((product) {
                      return DataRow(
                        cells: [
                          DataCell(Text(product.name)),
                          DataCell(
                            Text(
                              '${product.price.toStringAsFixed(0)}đ',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 100,
                              child: canEdit
                                  ? TextField(
                                controller: TextEditingController(
                                  text: product.quantity.toString(),
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    updateProductQuantity(
                                      order.id,
                                      product.name,
                                      int.parse(value),
                                    );
                                  }
                                },
                              )
                                  : Text(product.quantity.toString()),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${(product.price * product.quantity).toStringAsFixed(0)}đ',
                              style: TextStyle(
                                color: mainBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Total Amount
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: mainBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: mainBlue.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng tiền',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${order.total.toStringAsFixed(0)}đ',
                      style: TextStyle(
                        color: mainBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      canEdit ? 'Hủy' : 'Đóng',
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                  ),
                  if (canEdit) ...[
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Xử lý lưu thay đổi
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Lưu thay đổi',style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderUpdate(BuildContext context, Order order) {
    _showOrderDetails(context, order, true);
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}