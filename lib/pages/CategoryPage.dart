import 'package:flutter/material.dart';
import 'package:phoneshop/providers/Product_provider.dart';
import 'package:phoneshop/widgets/ItemsWidget.dart';
import 'package:provider/provider.dart';

class Screen2 extends StatefulWidget {
  Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final List<String> brand = ['iphone', 'samsung', 'xiaomi', 'oppo'];
  @override
  void dispose() {
    // Reset filter khi rời khỏi trang
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.resetFilter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //lấy productprovider
    Future.microtask(() async {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      await productProvider.loadProducts();
      print("products after load: ${productProvider.products}");
    });

    return Scaffold(
        backgroundColor: Color(0xFFEDECF2),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  brand.length,
                  (index) => Consumer<ProductProvider>(
                    builder: (context, provider, _) {
                      bool isSelected =
                          provider.selectedBrand == brand[index].toLowerCase();
                      return GestureDetector(
                        onTap: () {
                          // Kiểm tra và reset/filter trong Consumer
                          if (provider.selectedBrand ==
                              brand[index].toLowerCase()) {
                            provider.resetFilter();
                          } else {
                            provider.filterByBrand(brand[index]);
                          }
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue[100]
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                'https://cdn2.cellphones.com.vn/insecure/rs:fill:358:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/s/s/ss-s24-ultra-xam-222.png',
                                width: 30, // Giảm kích thước ảnh thêm
                                height: 30, // Giảm kích thước ảnh thêm
                              ),
                              SizedBox.shrink(), // Thay thế SizedBox cố định
                              Text(
                                brand[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11, // Giảm font size thêm
                                  color:
                                      isSelected ? Colors.blue : Colors.black,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
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
            Expanded(
                flex: 9,
                child: Container(
                  child: Consumer<ProductProvider>(
                      builder: (context, provider, _) {
                    //kiểm tra nếu đang tải dữ liệu
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    //truyền danh sách sản phẩm vào ItemsWidget
                    return ListView(
                      // Thay SingleChildScrollView bằng ListView
                      //padding: const EdgeInsets.only(top: 15),
                      children: [
                        ItemsWidget(products: provider.products),
                        SizedBox(
                            height: 80), // Thêm space cho bottom navigation bar
                      ],
                    );
                  }),
                ))
          ],
        ));
  }
}
