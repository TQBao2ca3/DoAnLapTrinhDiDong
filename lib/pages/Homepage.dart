import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoneshop/pages/CartPage.dart';
import 'package:phoneshop/pages/CategoryPage.dart';
import 'package:phoneshop/pages/ListProductPage.dart';
import 'package:phoneshop/pages/PersonPage.dart';
import 'package:phoneshop/providers/CartItems_Provider.dart';
import 'package:phoneshop/providers/Product_provider.dart';
import 'package:phoneshop/providers/user_provider.dart';
import 'package:phoneshop/services/userPreference.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  String currentSearchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCart();
    });
  }

  Future<void> _initializeCart() async {
    final userId = await UserPreferences.getUserId();
    if (userId != null) {
      print('HomeScreen - Initializing cart with userId: $userId');
      await context.read<CartProvider>().initializeWithUserId(userId);
    }
  }

  List<Widget> get _screens => [
    Screen1(
      key: ValueKey('screen1_$currentSearchQuery'),
      searchQuery: currentSearchQuery,
    ),
    Screen2(
      key: ValueKey('screen2_$currentSearchQuery'),
      searchQuery: currentSearchQuery,
    ),
    const Screen3(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == 1 && index != 1) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
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

  void _handleSearch() {
    final query = searchController.text.trim();
    print("HomeScreen - Search button pressed with query: $query");
    if (query.isNotEmpty) {
      setState(() {
        currentSearchQuery = query;
      });
    }
  }

  void _resetSearch() {
    setState(() {
      currentSearchQuery = '';
      searchController.clear();
    });
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
            backgroundColor: const Color(0xFFEDECF2),
            toolbarHeight: 70,
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(  // Đổi từ TextFormField sang TextField
                            controller: searchController,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                              hintText: "Bạn đang tìm gì...?",
                              hintStyle: const TextStyle(fontSize: 14),
                              isDense: true,
                              suffixIcon: searchController.text.isNotEmpty
                                  ? IconButton(
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: _resetSearch,
                              )
                                  : null,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            textInputAction: TextInputAction.search,
                            onChanged: (value) {
                              setState(() {
                                if (value.trim().isEmpty && currentSearchQuery.isNotEmpty) {
                                  _resetSearch();
                                }
                              });
                            },
                            onSubmitted: (value) {
                              if (value.trim().isNotEmpty) {
                                _handleSearch();
                              }
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(25)),
                            onTap: () {
                              _handleSearch();
                              FocusScope.of(context).unfocus();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.search,
                                size: 20,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
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
                        builder: (context) => const CartPage(),
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
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              if (_selectedIndex == 1 && index != 1) {
                final productProvider = Provider.of<ProductProvider>(context, listen: false);
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
              Icon(Icons.home, size: 30, color: Colors.white),
              Icon(Icons.list, size: 30, color: Colors.white),
              Icon(Icons.person, size: 30, color: Colors.white),
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