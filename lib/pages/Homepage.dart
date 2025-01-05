import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoneshop/models/Cart.dart';
import 'package:phoneshop/widgets/CategoriesWidget.dart';
import 'package:phoneshop/widgets/HomeAppBar.dart';
import 'package:phoneshop/widgets/ItemsWidget.dart';

class HomePage extends StatelessWidget {
  final Cart cart;

  const HomePage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Thêm SafeArea
        child: Column(
          children: [
            const HomeAppBar(tooltipMessage: "Nhấn để xem giỏ hàng"),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFEDECF2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: ListView(
                  // Thay SingleChildScrollView bằng ListView
                  padding: const EdgeInsets.only(top: 15),
                  children: [
                    Padding(
                      // Wrap search bar trong Padding
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              // Thay Container width cố định bằng Expanded
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: " Bạn đang tìm gì...?",
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.camera_alt,
                              size: 27,
                              color: Colors.lightBlue,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10,
                      ),
                      child: Text(
                        "Danh Mục",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                    const CategoriesWidget(),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        onTap: (index) {},
        height: 70,
        color: Colors.lightBlue,
        items: const [
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            CupertinoIcons.mail,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.list,
            size: 30,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
