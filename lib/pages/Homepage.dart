import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:phoneshop/models/Cart.dart';
import 'package:phoneshop/pages/CartPage.dart';
import 'package:phoneshop/pages/CategoryPage.dart';
import 'package:phoneshop/pages/ListProductPage.dart';
import 'package:phoneshop/pages/PersonPage.dart';
import 'package:phoneshop/widgets/HomeAppBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.cart});
  final Cart cart;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late final List<Widget> _screens = [
    const Screen1(),
    CategoryPage(searchQuery: _searchQuery),
    const PersonPage(),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onSearch() {
    setState(() {
      _searchQuery = _searchController.text.trim();
      if (_selectedIndex != 1) {
        _selectedIndex = 1;
        _pageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      // Rebuild CategoryPage với query mới
      _screens[1] = CategoryPage(searchQuery: _searchQuery);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 2
          ? null
          : PreferredSize(
        preferredSize: Size.fromHeight(_selectedIndex == 0 ? 120 : 60), // Điều chỉnh chiều cao dựa vào index
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 60,
                child: HomeAppBar(
                  cart: widget.cart,
                  tooltipMessage: "Shopping Cart",
                ),
              ),
              if (_selectedIndex == 0) // Chỉ hiển thị thanh tìm kiếm ở trang chủ
                Container(
                  height: 60,
                  color: const Color(0xFFEDECF2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: " Bạn đang tìm gì...?",
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                                      suffixIcon: _searchController.text.isNotEmpty
                                          ? IconButton(
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {}); // Cập nhật UI
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      )
                                          : null,
                                    ),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),
                                    onFieldSubmitted: (value) => _onSearch(),
                                    onChanged: (value) {
                                      setState(() {}); // Cập nhật UI để hiển thị/ẩn nút xóa
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _onSearch,
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.search,
                                      size: 25,
                                      color: Colors.lightBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.home,
                size: 30,
                color: Colors.white,
              ),

            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.list,
                size: 30,
                color: Colors.white,
              ),

            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ),

            ],
          ),
        ],
      ),
    );
  }
}