import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoneshop/providers/ProductHomePage_Provider.dart';
import 'package:phoneshop/providers/Product_provider.dart';
import 'package:phoneshop/widgets/ItemsWidget.dart';
import 'package:provider/provider.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  @override
  void initState() {
    super.initState();
    //lấy ProductProvider và gọi loadProducts
    Future.microtask(() async {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      await productProvider.loadProducts();
      print("products after load: ${productProvider.products}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Thêm SafeArea
        child: Column(
          children: [
            //const HomeAppBar(tooltipMessage: "Nhấn để xem giỏ hàng"),
            Expanded(
              child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDECF2),
                  ),
                  child: Consumer<ProductProvider>(
                      builder: (context, provider, _) {
                    //kiểm tra nếu đang tải dữ liệu
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    //truyền danh sách sản phẩm vào ItemsWidget
                    return ListView(
                      padding: const EdgeInsets.only(top: 15),
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15, bottom: 10),
                          child: Text(
                            "Top Bán Chạy",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlue),
                          ),
                        ),
                        ItemsWidget(
                          products: provider.products,
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                      ],
                    );
                  })),
            ),
          ],
        ),
      ),
    );
  }
}
