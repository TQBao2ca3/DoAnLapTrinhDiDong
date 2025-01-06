import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoneshop/models/Cart.dart';
import 'package:phoneshop/pages/CartPage.dart';
import 'package:phoneshop/pages/CategoryPage.dart';
import 'package:phoneshop/pages/ListProductPage.dart';
import 'package:phoneshop/pages/PersonPage.dart';
import 'package:phoneshop/widgets/CategoriesWidget.dart';
import 'package:phoneshop/widgets/HomeAppBar.dart';
import 'package:phoneshop/widgets/ItemsWidget.dart';
import 'CategoryPage.dart';
import 'PersonPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.cart});
  final Cart cart;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Mã index màn hình đang hiển thị
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  //Danh sách các màn hình
  final List<Widget> _screens = [
    const Screen1(),
    Screen2(),
    const Screen3(),
  ];

  //Hàm xử lý khi nhấn vào một icon trên thanh điều hướng
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Điều hướng PageView tới trang tương ứng
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

    //Điều hướng đến trang tương ứng trong PageView
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Kiểm tra nếu ở màn hình 3 thì không hiển thị AppBar
      appBar: _selectedIndex == 2
          ? null
          : AppBar(
              // Ẩn icon arrow back
              automaticallyImplyLeading: false,

              backgroundColor: Color(0xFFEDECF2),
              title: Padding(
                // Wrap search bar trong Padding
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                          const Icon(
                            Icons.camera_alt,
                            size: 27,
                            color: Colors.lightBlue,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CartPage(cart: widget.cart)));
                      },
                      child: const Icon(
                        Icons.shopping_cart,
                        size: 27,
                        color: Colors.lightBlue,
                      ),
                    )
                  ],
                ),
              ),
            ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex =
                index; // Đồng bộ _selectedIndex với trạng thái của trang
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        backgroundColor: Colors.transparent,
        onTap: _onItemTapped,
        height: 70,
        color: Colors.lightBlue,
        items: const [
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.list,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
