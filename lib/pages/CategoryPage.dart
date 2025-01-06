import 'package:flutter/material.dart';
import 'package:phoneshop/widgets/ItemsWidget.dart';

class Screen2 extends StatelessWidget {
  Screen2({super.key});
  final List<String> brand = ['iphone', 'samsung', 'xiaomi', 'oppo'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEDECF2),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: GridView.builder(
                  itemCount: brand.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: brand.length,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  padding: EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Image.network(
                          'https://cdn2.cellphones.com.vn/insecure/rs:fill:358:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/s/s/ss-s24-ultra-xam-222.png',
                          //fit: BoxFit.cover
                          width: 40,
                          height: 40,
                        ),
                        Text(
                          brand[index],
                          textAlign: TextAlign.center,
                        )
                      ],
                    );
                  }),
            ),
            Expanded(
              flex: 9,
              child: ListView(
                // Thay SingleChildScrollView bằng ListView
                //padding: const EdgeInsets.only(top: 15),
                children: [
                  ItemsWidget(),
                  const SizedBox(
                      height: 80), // Thêm space cho bottom navigation bar
                ],
              ),
            )
          ],
        ));
  }
}
