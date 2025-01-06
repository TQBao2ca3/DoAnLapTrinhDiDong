import 'package:flutter/material.dart';
import 'package:phoneshop/widgets/ItemsWidget.dart';
import 'package:phoneshop/widgets/Product_Order_Item.dart';

class ProductOrderScreen extends StatefulWidget {
  @override
  _ProductOrderScreen createState() => _ProductOrderScreen();
}

class _ProductOrderScreen extends State<ProductOrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            )),
        title: const Text("Đơn hàng"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.blue))
        ],
        bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black54,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(
                text: "Đang giao",
              ),
              Tab(
                text: "Đã giao",
              ),
              Tab(
                text: "Đã hủy",
              )
            ]),
      ),
      body: TabBarView(controller: _tabController, children: [
        _buildOrderList("Đang giao"),
        _buildOrderList("Đã giao"),
        _buildOrderList("Đã hủy")
      ]),
    );
  }
}

// Hàm để hiển thị danh sách đơn hàng theo từng tab
Widget _buildOrderList(String status) {
  return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: 5,
      itemBuilder: (context, index) {
        //ItemsWidget();
        return ItemOrder();
      });
}
