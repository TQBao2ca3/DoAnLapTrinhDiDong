import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:phoneshop/pages/userAuthentication.dart';
import 'package:phoneshop/services/api_service.dart';
import 'package:phoneshop/services/userPreference.dart';

import 'Model.dart';

class AdminOrdersScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const AdminOrdersScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  int selectedStatusDropdown = 0;
  String selectedStatus = 'all';
  final searchController = TextEditingController();
  String searchQuery = '';
  final mainBlue = const Color(0xFF0066CC);
  final String apiUrl = '${ApiService.baseUrl}';
  List<Order> orders = [];

  final currencyFormat = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  );

  String formatCurrency(double amount) {
    return currencyFormat.format(amount);
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/ordersStatus'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          orders = data.map((json) => Order.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tải dữ liệu: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách đơn hàng
    final filteredOrders = orders.where((order) {
      bool matchesSearch = searchQuery.isEmpty ||
          order.id.toString().toLowerCase().contains(searchQuery.toLowerCase());

      bool matchesStatus = selectedStatus == 'all' ||
          (() {
            switch (selectedStatus) {
              case 'pending':
                return order.status == 0;
              case 'approved':
                return order.status == 1;
              case 'completed':
                return order.status == 2;
              case 'cancelled':
                return order.status == -1;
              default:
                return true;
            }
          })();

      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: mainBlue,
        title: Text(
          'Quản lý đơn hàng',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18, // Slightly smaller for mobile
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.admin_panel_settings),
                  title: Text('Thông tin Admin'),
                  onTap: () {
                    Navigator.pop(context);
                    _showAdminInfoDialog();
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Đăng xuất'),
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutConfirmation();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchOrders,
        child: ListView(
          padding: const EdgeInsets.all(16), // Reduced padding for mobile
          children: [
            // Responsive stat cards (scrollable horizontally)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatCard(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Tổng đơn hàng',
                    value: orders.length.toString(),
                    color: mainBlue,
                  ),
                  _buildStatCard(
                    icon: Icons.pending_actions_outlined,
                    title: 'Chờ xử lý',
                    value: orders
                        .where((order) => order.status == 0)
                        .length
                        .toString(),
                    color: Colors.orange,
                  ),
                  _buildStatCard(
                    icon: Icons.check_circle_outline,
                    title: 'Đã duyệt',
                    value: orders
                        .where((order) => order.status == 1)
                        .length
                        .toString(),
                    color: Colors.blue,
                  ),
                  _buildStatCard(
                    icon: Icons.verified_outlined,
                    title: 'Hoàn thành',
                    value: orders
                        .where((order) => order.status == 2)
                        .length
                        .toString(),
                    color: Colors.green,
                  ),
                  _buildStatCard(
                    icon: Icons.cancel_outlined,
                    title: 'Đã hủy',
                    value: orders
                        .where((order) => order.status == -1)
                        .length
                        .toString(),
                    color: Colors.red,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Search and Filter Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Search Input
                    TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm đơn hàng...',
                        prefixIcon: Icon(Icons.search, color: mainBlue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Status Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
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
                          value: 'approved',
                          child: Text('Đã duyệt'),
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
                      onChanged: (value) {
                        setState(() => selectedStatus = value!);
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Orders List (Mobile-friendly Card List)
            ...filteredOrders.map((order) => _buildOrderCard(order)).toList(),
          ],
        ),
      ),
    );
  }

  // Stat Card for mobile (compact design)
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 150, // Fixed width for horizontal scrolling
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Mobile-friendly Order Card
  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (order.img != null && order.img!.isNotEmpty)
                  Container(
                    height: 120,
                    width: 120,
                    margin: EdgeInsets.only(bottom: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        order.img!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.grey[400],
                                size: 40,
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                Text(
                  'Đơn hàng #${order.id}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _buildStatusBadge(order.status),
              ],
            ),

            SizedBox(height: 12),

            // Customer Info
            Text(
              'Khách hàng: ${order.customerName}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              'Số điện thoại: ${order.phone}',
              style: TextStyle(color: Colors.grey[700]),
            ),

            SizedBox(height: 12),

            // Total and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ngày: ${order.date}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  formatCurrency(order.total),
                  style: TextStyle(
                    color: mainBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.visibility_outlined, size: 16),
                    label: Text('Chi tiết'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[50],
                      foregroundColor: mainBlue,
                    ),
                    onPressed: () => _showOrderDetails(context, order, false),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.edit_outlined, size: 16),
                    label: Text('Cập nhật'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[50],
                      foregroundColor: Colors.green,
                    ),
                    onPressed: () => _showOrderUpdate(context, order),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Status Badge (remains the same)
  Widget _buildStatusBadge(int status) {
    Color color;
    String text;

    switch (status) {
      case 0:
        color = Colors.orange;
        text = 'Chờ xử lý';
        break;
      case 1:
        color = Colors.blue;
        text = 'Đã duyệt';
        break;
      case 2:
        color = Colors.green;
        text = 'Hoàn thành';
        break;
      case -1:
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

  // Admin Info Dialog
  void _showAdminInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController(
          text: "${widget.user['username']}",
        );
        TextEditingController emailController = TextEditingController(
          text: "${widget.user['email']}",
        );
        TextEditingController phoneController = TextEditingController(
          text: "${widget.user['phone']}",
        );

        return AlertDialog(
          title: Text('Thông tin Admin'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final response = await http.put(
                    Uri.parse('$apiUrl/users/update'),
                    headers: {
                      'Content-Type': 'application/json',
                    },
                    body: json.encode({
                      'username': nameController.text,
                      'email': emailController.text,
                      'phone': phoneController.text,
                    }),
                  );

                  if (response.statusCode == 200) {
                    // Parse response data
                    final userData = json.decode(response.body);

                    // Update widget state with new user data
                    setState(() {
                      widget.user['username'] = nameController.text;
                      widget.user['email'] = emailController.text;
                      widget.user['phone'] = phoneController.text;
                    });

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cập nhật thông tin thành công!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Lỗi: ${json.decode(response.body)['message']}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã có lỗi xảy ra: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  // Logout Confirmation Dialog
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận đăng xuất'),
          content: Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Xóa token và userId khi đăng xuất
                await Future.wait([
                  UserPreferences.removeToken(),
                  UserPreferences.removeUserId(),
                ]);
                Navigator.of(context)
                  ..pop() // Dismiss dialog
                  ..pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => UserAuthentication()),
                  );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Order Details Dialog (Mobile-friendly)
  Future<void> _showOrderDetails(
      BuildContext context, Order order, bool canEdit) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/ordersStatus/${order.id}/details'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<OrderDetail> orderDetails =
            data.map((json) => OrderDetail.fromJson(json)).toList();

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (_, controller) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                controller: controller,
                children: [
                  // Order Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chi tiết đơn hàng #${order.id}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Divider(),

                  // Customer Info Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            icon: Icons.person_outline,
                            label: 'Khách hàng',
                            value: order.customerName,
                          ),
                          SizedBox(height: 12),
                          _buildInfoRow(
                            icon: Icons.phone_outlined,
                            label: 'Số điện thoại',
                            value: order.phone,
                          ),
                          SizedBox(height: 12),
                          _buildInfoRow(
                            icon: Icons.calendar_today_outlined,
                            label: 'Ngày đặt',
                            value: order.date,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Product Details
                  Text(
                    'Chi tiết sản phẩm',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),

                  // Product List
                  ...orderDetails
                      .map((detail) => Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    detail.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Số lượng: ${detail.quantity}'),
                                      Text('Dung lượng: ${detail.storage}'),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Đơn giá:'),
                                      Text(
                                        formatCurrency(detail.price ?? 0),
                                        style: TextStyle(
                                          color: mainBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Thành tiền:'),
                                      Text(
                                        formatCurrency(detail.total ?? 0),
                                        style: TextStyle(
                                          color: mainBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),

                  // Total Amount
                  Card(
                    color: mainBlue.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tổng tiền',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            formatCurrency(order.total),
                            style: TextStyle(
                              color: mainBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Close Button
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainBlue,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Đóng',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        throw Exception('Failed to load order details');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tải chi tiết đơn hàng: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Common Info Row for Details
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Order Update Dialog (Mobile-friendly)
  void _showOrderUpdate(BuildContext context, Order order) {
    // Lấy trạng thái hiện tại của đơn hàng
    int selectedStatus = order.status;

    // Tạo danh sách các trạng thái có thể chuyển đến dựa trên trạng thái hiện tại
    List<DropdownMenuItem<int>> getAvailableStatusItems() {
      return [
        DropdownMenuItem(
          value: 0,
          child: Text('Chờ xử lý'),
        ),
        DropdownMenuItem(
          value: 1,
          child: Text('Đã duyệt'),
        ),
        DropdownMenuItem(
          value: 2,
          child: Text('Hoàn thành'),
        ),
        DropdownMenuItem(
          value: -1,
          child: Text('Đã hủy'),
        ),
      ];
    }

    // Kiểm tra xem có cho phép thay đổi trạng thái không

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cập nhật đơn hàng #${order.id}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(),

              // Customer Info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        icon: Icons.person_outline,
                        label: 'Khách hàng',
                        value: order.customerName,
                      ),
                      SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.phone_outlined,
                        label: 'Số điện thoại',
                        value: order.phone,
                      ),
                      SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Ngày đặt',
                        value: order.date,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Status Dropdown
              Text(
                'Trạng thái đơn hàng:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: selectedStatus,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (int? value) {
                  if (value != null) {
                    setState(() {
                      selectedStatus = value;
                    });
                  }
                },
                items: getAvailableStatusItems(),
              ),

              SizedBox(height: 16),

              // Update Button
              // Xóa dòng này
// if (isEditable)

// Và thay thế bằng nút cập nhật không có điều kiện
              ElevatedButton(
                onPressed: () async {
                  try {
                    final response = await http.put(
                      Uri.parse('$apiUrl/ordersStatus/update/${order.id}'),
                      headers: {
                        'Content-Type': 'application/json',
                      },
                      body: json.encode({'status': selectedStatus}),
                    );

                    if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Cập nhật trạng thái thành công'),
                            backgroundColor: Colors.green),
                      );
                      Navigator.pop(context);
                      onUpdateSuccess();
                    } else {
                      throw Exception('Failed to update order status');
                    }
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lỗi khi cập nhật: $error'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlue,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Cập nhật trạng thái',
                  style: TextStyle(
                    color: Colors.white,
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

  // Refresh order list after successful update
  void onUpdateSuccess() {
    setState(() {
      // Gọi lại hàm fetchOrders để lấy danh sách đơn hàng mới
      fetchOrders();
    });
  }
}
