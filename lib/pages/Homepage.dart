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
  final TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  String currentSearchQuery = ''; // Thêm biến để theo dõi searchQuery

  // Chuyển _screens thành getter
  List<Widget> get _screens => [
    // Thêm key để force rebuild khi searchQuery thay đổi
    Screen1(
      key: ValueKey(currentSearchQuery),
      searchQuery: currentSearchQuery,
    ),
    Screen2(),
    const Screen3(),
  ];

  void _onItemTapped(int index) {
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
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFEDECF2),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              // Container cho thanh tìm kiếm
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      // TextField
                      Expanded(
                        child: TextFormField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 15),
                            hintText: "Bạn đang tìm gì...?",
                          ),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          onChanged: (value) {
                            setState(() {
                              if (value.trim().isEmpty) {
                                currentSearchQuery = '';
                              }
                            });
                          },
                        ),
                      ),
                      // Nút tìm kiếm
                      ElevatedButton(
                        onPressed: () {
                          final query = searchController.text.trim();
                          print("HomeScreen - Search button pressed with query: $query");
                          if (query.isNotEmpty) {
                            setState(() {
                              currentSearchQuery = query;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          padding: const EdgeInsets.all(15),
                        ),
                        child: const Icon(
                          Icons.search,
                          size: 28,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Icon giỏ hàng
              const SizedBox(width: 12),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(cart: widget.cart),
                    ),
                  );
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
    searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}