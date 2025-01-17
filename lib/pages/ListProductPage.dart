import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoneshop/providers/Product_provider.dart';
import 'package:phoneshop/widgets/ItemsWidget.dart';
import 'package:provider/provider.dart';
import 'package:phoneshop/models/Product.dart'; // Thêm import Product model

class Screen1 extends StatefulWidget {
  final String searchQuery;
  const Screen1({super.key, required this.searchQuery});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  @override
  void initState() {
    super.initState();
    //_loadProducts();
    Future.microtask(() => context.read<ProductProvider>().loadProducts());
  }

  // Future<void> _loadProducts() async {
  //   if (!mounted) return;

  //   final productProvider = Provider.of<ProductProvider>(context, listen: false);
  //   if (productProvider.products.isEmpty) {
  //     await productProvider.loadProducts();
  //   }
  // }

  // Sửa kiểu dữ liệu thành List<Product>
  List<Product> _filterProducts(List<Product> products, String query) {
    if (query.isEmpty) return products;

    return products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  void didUpdateWidget(Screen1 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      print('Search query updated: ${widget.searchQuery}');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Screen1 building with query: ${widget.searchQuery}');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFEDECF2),
                ),
                child: Consumer<ProductProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final filteredProducts =
                        _filterProducts(provider.products, widget.searchQuery);

                    if (widget.searchQuery.isNotEmpty &&
                        filteredProducts.isEmpty) {
                      return Center(
                        child: Text(
                          'Không tìm thấy sản phẩm phù hợp với "${widget.searchQuery}"',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.only(top: 15),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, bottom: 10),
                          child: Text(
                            widget.searchQuery.isEmpty
                                ? "Top Bán Chạy"
                                : "Kết quả tìm kiếm (${filteredProducts.length})",
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlue),
                          ),
                        ),
                        ItemsWidget(
                          products: filteredProducts,
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
