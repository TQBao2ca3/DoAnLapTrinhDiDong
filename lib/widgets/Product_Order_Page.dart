import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:developer' as developer;
import 'package:phoneshop/widgets/Product_Order_Item.dart';

// Mô hình dữ liệu cho chi tiết đơn hàng
class OrderDetail {
  final int orderId;
  final String imageUrl;
  final String name;
  final int quantity;
  final String storage;
  final double price;
  final double total;  // Thêm trường total
  final int status;

  // Enum để quản lý trạng thái đơn hàng
  static const Map<int, String> statusMap = {
    0: 'Chờ duyệt',
    1: 'Đang giao',
    2: 'Đã giao',
  };

  OrderDetail({
    required this.orderId,
    required this.imageUrl,
    required this.name,
    required this.quantity,
    required this.storage,
    required this.price,
    required this.total,  // Thêm total vào constructor
    required this.status,
  });

  // Phương thức chuyển đổi từ JSON sang đối tượng OrderDetail
  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      orderId: json['orderId'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      storage: json['storage'] ?? '',
      price: (json['price'] is num) ? json['price'].toDouble() : 0.0,
      total: (json['total'] is num) ? json['total'].toDouble() : 0.0,  // Parse total
      status: json['status'] ?? 0,
    );
  }

  // So sánh hai đơn hàng để kiểm tra sự thay đổi
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderDetail &&
        orderId == other.orderId &&
        imageUrl == other.imageUrl &&
        name == other.name &&
        quantity == other.quantity &&
        storage == other.storage &&
        price == price &&
        total == other.total &&  // Thêm total vào so sánh
        status == other.status;
  }

  @override
  int get hashCode {
    return Object.hash(
      orderId,
      imageUrl,
      name,
      quantity,
      storage,
      price,
      total,  // Thêm total vào hash
      status,
    );
  }
}

// Màn hình đơn hàng
class ProductOrderScreen extends StatefulWidget {
  final int userId;

  const ProductOrderScreen({Key? key, required this.userId}) : super(key: key);

  @override
  ProductOrderScreenState createState() => ProductOrderScreenState();
}

class ProductOrderScreenState extends State<ProductOrderScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  List<OrderDetail> _orders = [];
  bool _isLoading = true;
  Timer? _refreshTimer;
  final List<int> _tabStatuses = [0, 1, 2];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchOrders();
    _setupPeriodicRefresh();

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _fetchOrders();
      }
    });
  }

  void _setupPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {  // Tăng thời gian refresh lên 30s
      if (mounted) {
        _fetchOrders();
      }
    });
  }

  Future<void> _fetchOrders() async {
    if (!mounted) return;

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.7:3000/api/orders/${widget.userId}'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Không thể kết nối đến máy chủ');
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<OrderDetail> fetchedOrders =
        jsonData.map((data) => OrderDetail.fromJson(data)).toList();

        if (!_listEquals(_orders, fetchedOrders)) {
          setState(() {
            _orders = fetchedOrders;
            _isLoading = false;
          });

          developer.log(
              'Danh sách đơn hàng đã được cập nhật',
              name: 'OrderDebug',
              error: {
                'total_orders': fetchedOrders.length,
                'orders': fetchedOrders.map((order) => {
                  'orderId': order.orderId,
                  'name': order.name,
                  'status': order.status
                }).toList()
              }
          );
        }
      } else if (response.statusCode == 404) {
        setState(() {
          _orders = [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        _showError('Không thể tải đơn hàng');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      String errorMessage = 'Lỗi kết nối';
      if (e is TimeoutException) {
        errorMessage = 'Kết nối quá hạn';
      }
      _showError(errorMessage);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _listEquals(List<OrderDetail> list1, List<OrderDetail> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _tabController.removeListener(() {});
    _tabController.dispose();
    super.dispose();
  }

  void _switchToTab(int index) {
    if (mounted) {
      setState(() {
        _tabController.animateTo(index);
      });
    }
  }

  Widget _buildOrderList(int status) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredOrders = _orders
        .where((order) => order.status == status)
        .toList();

    if (filteredOrders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Không có đơn hàng',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return ItemOrder(
          orderDetails: order,
          onOrderStatusUpdated: () {
            _fetchOrders().then((_) {
              if (mounted) {
                _switchToTab(2);
              }
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
        ),
        title: const Text(
          "Đơn hàng",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black54,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: "Chờ duyệt"),
            Tab(text: "Đang giao"),
            Tab(text: "Đã giao"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabStatuses.map(_buildOrderList).toList(),
      ),
    );
  }
}