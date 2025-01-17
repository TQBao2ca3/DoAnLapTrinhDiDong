import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoneshop/pages/CartPage.dart';
import 'package:phoneshop/pages/CategoryPage.dart';
import 'package:phoneshop/pages/ListProductPage.dart';
import 'package:phoneshop/pages/PersonPage.dart';
import 'package:phoneshop/providers/CartItems_Provider.dart';
import 'package:phoneshop/providers/Product_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // Bỏ tham số cart

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  String currentSearchQuery = '';

  List<Widget> get _screens => [
        Screen1(
          key: ValueKey(currentSearchQuery),
          searchQuery: currentSearchQuery,
        ),
        Screen2(),
        const Screen3(),
      ];

  void _onItemTapped(int index) {
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
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
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
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: searchController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      hintText: "Bạn đang tìm gì...?",
                                    ),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value.trim().isEmpty) {
                                          currentSearchQuery = '';
                                        }
                                      });
                                    },
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final query = searchController.text.trim();
                                    print(
                                        "HomeScreen - Search button pressed with query: $query");
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
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CartPage(), // Bỏ tham số cart
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              const Icon(
                                Icons.shopping_cart,
                                size: 27,
                                color: Colors.lightBlue,
                              ),
                              if (cartProvider.getItemCount() > 0)
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      '${cartProvider.getItemCount()}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
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
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
