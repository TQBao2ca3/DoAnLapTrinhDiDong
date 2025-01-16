import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoneshop/models/Cart.dart';
import 'package:phoneshop/pages/CartPage.dart';
import 'package:phoneshop/pages/CategoryPage.dart';
import 'package:phoneshop/pages/ListProductPage.dart';
import 'package:phoneshop/pages/PersonPage.dart';
import 'package:phoneshop/providers/Product_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.cart});
  final Cart cart;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final List<Widget> _screens = [
    const Screen1(),
    Screen2(),
    const Screen3(),
  ];

  void _onItemTapped(int index) {
    // Reset filter khi chuyển khỏi trang category (Screen2)
    if (_selectedIndex == 1 && index != 1) {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      productProvider.resetFilter();
    }

    setState(() {
      _selectedIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // Reset filter khi vuốt khỏi trang category (Screen2)
          if (_selectedIndex == 1 && index != 1) {
            final productProvider =
                Provider.of<ProductProvider>(context, listen: false);
            productProvider.resetFilter();
          }

          setState(() {
            _selectedIndex = index;
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
