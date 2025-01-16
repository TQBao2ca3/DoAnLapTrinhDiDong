import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:phoneshop/widgets/Product_Order_Item.dart';

// Định nghĩa class OrderDetail ở ngoài
class OrderDetail {
  final String imageUrl;
  final String name;
  final int quantity;
  final String storage;
  final double price;
  final double total;

  OrderDetail({
    required this.imageUrl,
    required this.name,
    required this.quantity,
    required this.storage,
    required this.price,
    required this.total,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      imageUrl: json['imageUrl'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      storage: json['storage'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      total: json['total']?.toDouble() ?? 0.0,
    );
  }
}

class ProductOrderScreen extends StatefulWidget {
  final int userId;

  const ProductOrderScreen({
    Key? key,
    required this.userId
  }) : super(key: key);

  @override
  ProductOrderScreenState createState() => ProductOrderScreenState();
}

class ProductOrderScreenState extends State<ProductOrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<OrderDetail> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.7:3000/api/orders/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<OrderDetail> fetchedOrders = jsonData
            .map((data) => OrderDetail.fromJson(data))
            .toList();

        setState(() {
          orders = fetchedOrders;
          isLoading = false;
        });
      } else {
        setState(() {
          orders = [];
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể tải đơn hàng')),
        );
      }
    } catch (e) {
      setState(() {
        orders = [];
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi kết nối: $e')),
      );
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget buildOrderList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orders.isEmpty) {
      return const Center(child: Text('Không có đơn hàng'));
    }

    return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return ItemOrder(
            orderDetails: order,
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.blue,
            )
        ),
        title: const Text("Đơn hàng"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.blue)
          )
        ],
        bottom: TabBar(
            controller: tabController,
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black54,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: "Đang giao"),
              Tab(text: "Đã giao"),
              Tab(text: "Đã hủy")
            ]
        ),
      ),
      body: TabBarView(
          controller: tabController,
          children: [
            buildOrderList(),
            buildOrderList(),
            buildOrderList()
          ]
      ),
    );
  }
}