import 'package:flutter/material.dart';
import 'package:phoneshop/providers/Product_provider.dart';
import 'package:phoneshop/widgets/ItemsWidget.dart';
import 'package:provider/provider.dart';

class Screen2 extends StatefulWidget {
  final String searchQuery;
  const Screen2({super.key, required this.searchQuery});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final List<String> brandImage = [
    'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/732px-Apple_logo_black.svg.png',
    'https://images.samsung.com/is/image/samsung/assets/vn/about-us/brand/logo/pc/720_600_1.png?\$720_N_PNG\$',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Xiaomi_logo_%282021-%29.svg/225px-Xiaomi_logo_%282021-%29.svg.png',
    'https://static.wikia.nocookie.net/logos/images/2/25/Oppo_2013.png/revision/latest?cb=20230414094522&path-prefix=vi',
  ];
  final List<String> brand = ['iphone', 'samsung', 'xiaomi', 'oppo'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      productProvider.loadProducts();
    });
  }

  @override
  void dispose() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.resetFilter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECF2),
      body: SafeArea(
        child: Column(
          children: [
            // Brand selection row
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  brand.length,
                      (index) => Consumer<ProductProvider>(
                    builder: (context, provider, _) {
                      bool isSelected = provider.selectedBrand == brand[index].toLowerCase();
                      return GestureDetector(
                        onTap: () {
                          if (provider.selectedBrand == brand[index].toLowerCase()) {
                            provider.resetFilter();
                          } else {
                            provider.filterByBrand(brand[index]);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue[100] : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                brandImage[index],
                                width: 25,
                                height: 25,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.phone_android, size: 25);
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 2),
                              Text(
                                brand[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isSelected ? Colors.blue : Colors.black,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Product list
            Expanded(
              child: Consumer<ProductProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Lọc sản phẩm dựa trên searchQuery
                  var filteredProducts = provider.products;
                  if (widget.searchQuery.isNotEmpty) {
                    filteredProducts = filteredProducts.where((product) {
                      return product.name.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
                          product.description.toLowerCase().contains(widget.searchQuery.toLowerCase());
                    }).toList();
                  }

                  // Hiển thị thông báo khi không có kết quả tìm kiếm
                  if (filteredProducts.isEmpty && widget.searchQuery.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Không tìm thấy sản phẩm nào cho\n"${widget.searchQuery}"',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.only(bottom: 90),
                    children: [
                      ItemsWidget(products: filteredProducts),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}