import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoneshop/models/Cart.dart';
import 'package:phoneshop/widgets/CategoriesWidget.dart';
import 'package:phoneshop/widgets/HomeAppBar.dart';
import 'package:phoneshop/widgets/ItemsWidget.dart';

class HomePage extends StatelessWidget {
  final Cart cart;

  HomePage({Key? key, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(  // Thêm SafeArea
        child: Column(
          children: [
            HomeAppBar(tooltipMessage: "Nhấn để xem giỏ hàng"),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFEDECF2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: ListView(  // Thay SingleChildScrollView bằng ListView
                  padding: EdgeInsets.only(top: 15),
                  children: [
                    Padding(  // Wrap search bar trong Padding
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Expanded(  // Thay Container width cố định bằng Expanded
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: " Bạn đang tìm gì...?",
                                ),
                              ),
                            ),
                            Icon(
                              Icons.camera_alt,
                              size: 27,
                              color: Colors.lightBlue,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
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
                    CategoriesWidget(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                    SizedBox(height: 80),  // Thêm space cho bottom navigation bar
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
        items: [
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