import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoneshop/widgets/ItemsWidget.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

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
                child: ListView(
                  // Thay SingleChildScrollView bằng ListView
                  padding: const EdgeInsets.only(top: 15),
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15, bottom: 10),
                      child: Text(
                        "Top Bán Chạy",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                    ItemsWidget(),
                    const SizedBox(
                        height: 80), // Thêm space cho bottom navigation bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
