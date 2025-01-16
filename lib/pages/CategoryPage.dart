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
  final List<String> brandImage = [
    'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/732px-Apple_logo_black.svg.png',
    'https://images.samsung.com/is/image/samsung/assets/vn/about-us/brand/logo/pc/720_600_1.png?\$720_N_PNG\$',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Xiaomi_logo_%282021-%29.svg/225px-Xiaomi_logo_%282021-%29.svg.png',
    'https://static.wikia.nocookie.net/logos/images/2/25/Oppo_2013.png/revision/latest?cb=20230414094522&path-prefix=vi',
  ];
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
                                brandImage[index],
                                width: 30,
                                height: 30,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.phone_android,
                                      size:
                                          30); // Icon mặc định khi load ảnh lỗi
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
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
