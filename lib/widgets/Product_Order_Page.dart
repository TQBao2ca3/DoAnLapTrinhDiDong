import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:developer' as developer;
import 'package:phoneshop/widgets/Product_Order_Item.dart';

class OrderDetail {
  final int orderId;
  final String imageUrl;
  final String name;
  final int quantity;
  final String storage;
  final double price;
  final double total; // Thêm trường total
  final int status;

  // Cập nhật statusMap để bao gồm trạng thái đã hủy
  static const Map<int, String> statusMap = {
    0: 'Chờ duyệt',
    1: 'Đang giao',
    2: 'Đã giao',
    -1: 'Đã hủy', // Thêm trạng thái đã hủy
  };

  OrderDetail({
    required this.orderId,
    required this.imageUrl,
    required this.name,
    required this.quantity,
    required this.storage,
    required this.price,
    required this.total,
    required this.status,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      orderId: json['orderId'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      storage: json['storage'] ?? '',
      price: (json['price'] is num) ? json['price'].toDouble() : 0.0,
      total: (json['total'] is num)
          ? json['total'].toDouble()
          : 0.0, // Parse total
      status: json['status'] ?? 0,
    );
  }

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
        total == other.total && // Thêm total vào so sánh
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
      total, // Thêm total vào hash
      status,
    );
  }
}

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

  // Định nghĩa danh sách status và tab tương ứng
  final List<Map<String, dynamic>> _tabs = [
    {'status': 0, 'text': 'Chờ duyệt'},
    {'status': 1, 'text': 'Đang giao'},
    {'status': 2, 'text': 'Đã giao'},
    {'status': -1, 'text': 'Đã hủy'},
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _fetchOrders();
    _setupPeriodicRefresh();

    // Lắng nghe sự kiện thay đổi tab
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _fetchOrders();
      }
    });
  }

  void _setupPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      // Tăng thời gian refresh lên 30s
      if (mounted) {
        _fetchOrders();
      }
    });
  }

  Future<void> _fetchOrders() async {
    if (!mounted) return;

    try {
      final response = await http
          .get(
        Uri.parse('http://192.168.1.9:3000/api/orders/${widget.userId}'),
      )
          .timeout(
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

          developer.log('Danh sách đơn hàng đã được cập nhật',
              name: 'OrderDebug',
              error: {
                'total_orders': fetchedOrders.length,
                'orders': fetchedOrders
                    .map((order) => {
                          'orderId': order.orderId,
                          'name': order.name,
                          'status': order.status
                        })
                    .toList()
              });
        } else {
          setState(() {
            _isLoading = false;
          });
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
    _tabController.dispose();
    super.dispose();
  }

  void _switchToTab(int index) {
    if (mounted && index >= 0 && index < _tabs.length) {
      setState(() {
        _tabController.animateTo(index);
      });
    }
  }

  Widget _buildOrderList(Map<String, dynamic> tabInfo) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredOrders =
        _orders.where((order) => order.status == tabInfo['status']).toList();

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
                if (order.status == -1) {
                  _switchToTab(3); // Chuyển đến tab Đã hủy
                } else if (order.status == 2) {
                  _switchToTab(2); // Chuyển đến tab Đã giao
                }
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
            fontSize: 13,
          ),
          padding: EdgeInsets.zero,
          labelPadding: const EdgeInsets.symmetric(horizontal: 4),
          indicatorWeight: 3,
          tabAlignment: TabAlignment.fill,
          tabs: _tabs
              .map((tab) => Tab(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(tab['text']),
                    ),
                  ))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs
            .map((tabInfo) => RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await _fetchOrders();
                  },
                  child: _buildOrderList(tabInfo),
                  color: Colors.blue,
                  backgroundColor: Colors.white,
                ))
            .toList(),
      ),
    );
  }
}
