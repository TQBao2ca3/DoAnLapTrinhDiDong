import 'package:flutter/material.dart';
import 'package:phoneshop/models/Product.dart';
import 'package:phoneshop/pages/ItemPage.dart';

class ItemsWidget extends StatelessWidget {
  final List<Product> products = [
    Product(
      id: 1,
      title: "iPhone 15 Pro Max",
      description:
          "iPhone 15 Pro Max sở hữu màn hình 6.7 inch với công nghệ ProMotion, chip A17 Pro mạnh mẽ, camera chuyên nghiệp 48MP với khả năng zoom quang học 5x.",
      image: "assets/images/1.png",
      price: 33990000,
      originalPrice: 32990000,
      discount: 10,
      storage: ['128GB', '256GB', '512GB', '1TB'],
      colors: ['Đen', 'Xám', 'Trắng', 'Hồng'],
      createAt: DateTime(2023, 9, 22),
      rating: 4.9,
      reviewCount: 668,
    ),
    Product(
      id: 2,
      title: "Samsung Galaxy S24 Ultra",
      description:
          "Samsung Galaxy S24 Ultra trang bị chip Snapdragon 8 Gen 3, màn hình Dynamic AMOLED 2X 6.8 inch, camera 200MP với AI tiên tiến.",
      image: "assets/images/2.png",
      price: 31990000,
      originalPrice: 30990000,
      discount: 15,
      storage: ['256GB', '512GB', '1TB'],
      colors: ['Đen', 'Xám', 'Trắng', 'Hồng'],
      createAt: DateTime(2024, 1, 17),
      rating: 4.8,
      reviewCount: 425,
    ),
    Product(
      id: 3,
      title: "OPPO Find X7 Ultra",
      description:
          "OPPO Find X7 Ultra với camera 1-inch LYT-900, chip Dimensity 9300, sạc nhanh 100W, màn hình LTPO OLED 6.82 inch.",
      image: "assets/images/3.png",
      price: 24990000,
      originalPrice: 22990000,
      discount: 5,
      storage: ['256GB', '512GB'],
      colors: ['Đen', 'Xám', 'Trắng', 'Hồng'],
      createAt: DateTime(2024, 1, 5),
      rating: 4.7,
      reviewCount: 289,
    ),
    Product(
      id: 4,
      title: "Xiaomi 14 Pro",
      description:
          "Xiaomi 14 Pro được trang bị Snapdragon 8 Gen 3, màn hình LTPO 6.73 inch, camera Leica 50MP, sạc nhanh 120W.",
      image: "assets/images/4.png",
      price: 22990000,
      originalPrice: 21990000,
      discount: 5,
      storage: ['256GB', '512GB'],
      colors: ['Đen', 'Xám', 'Trắng', 'Hồng'],
      createAt: DateTime(2024, 1, 15),
      rating: 4.6,
      reviewCount: 156,
    ),
    Product(
      id: 5,
      title: "Google Pixel 8 Pro",
      description:
          "Google Pixel 8 Pro với chip Tensor G3, camera 50MP được tối ưu bởi AI, màn hình OLED 6.7 inch 120Hz.",
      image: "assets/images/5.png",
      price: 25990000,
      originalPrice: 24990000,
      discount: 10,
      storage: ['128GB', '256GB', '512GB'],
      colors: ['Đen', 'Xám', 'Trắng', 'Hồng'],
      createAt: DateTime(2023, 10, 4),
      rating: 4.7,
      reviewCount: 342,
    ),
    Product(
      id: 6,
      title: "OnePlus 12",
      description:
          "OnePlus 12 sở hữu Snapdragon 8 Gen 3, màn hình AMOLED 6.82 inch, camera 50MP với ống kính Hasselblad.",
      image: "assets/images/6.png",
      price: 19990000,
      originalPrice: 18990000,
      discount: 3,
      storage: ['256GB', '512GB'],
      colors: ['Đen', 'Xám', 'Trắng', 'Hồng'],
      createAt: DateTime(2024, 1, 23),
      rating: 4.8,
      reviewCount: 178,
    ),
    Product(
      id: 7,
      title: "iPhone 15 128GB",
      description:
          "iPhone 15 với chip A16 Bionic, Dynamic Island, camera kép 48MP, sạc USB-C và thiết kế mới với nhiều màu sắc.",
      image: "assets/images/7.png",
      price: 21990000,
      originalPrice: 20990000,
      discount: 5,
      storage: ['128GB', '256GB', '512GB'],
      colors: ['Đen', 'Xám', 'Trắng', 'Hồng'],
      createAt: DateTime(2023, 9, 22),
      rating: 4.8,
      reviewCount: 542,
    ),
    Product(
      id: 8,
      title: "Samsung Galaxy Z Fold5",
      description:
          "Samsung Galaxy Z Fold5 với màn hình gập 7.6 inch, Snapdragon 8 Gen 2, thiết kế bản lề mới và camera chuyên nghiệp.",
      image: "assets/images/8.png",
      price: 35990000,
      originalPrice: 34990000,
      discount: 8,
      storage: ['256GB', '512GB', '1TB'],
      colors: ['Đen', 'Xám', 'Trắng', 'Hồng'],
      createAt: DateTime(2023, 7, 26),
      rating: 4.7,
      reviewCount: 389,
    ),
    Product(
      id: 9,
      title: "OPPO Find N3 Flip",
      description:
          "OPPO Find N3 Flip với thiết kế gập vỏ sò độc đáo, màn hình phụ lớn, camera 50MP và sạc nhanh SUPERVOOC.",
      image: "assets/images/9.png",
      price: 22990000,
      originalPrice: 21990000,
      discount: 6,
      storage: ['256GB', '512GB'],
      colors: ['Đen', 'Xám', 'Trắng', 'Hồng'],
      createAt: DateTime(2023, 10, 12),
      rating: 4.6,
      reviewCount: 245,
    ),
    Product(
      id: 10,
      title: "Xiaomi Redmi Note 13 Pro+",
      description:
          "Redmi Note 13 Pro+ với camera 200MP, màn hình AMOLED 6.67 inch 120Hz, sạc nhanh 120W và thiết kế premium.",
      image: "assets/images/10.png",
      price: 11990000,
      originalPrice: 10990000,
      discount: 5,
      storage: ['256GB', '512GB'],
      colors: ['Đen', 'Xám', 'Trắng', 'Hồng'],
      createAt: DateTime(2023, 12, 29),
      rating: 4.5,
      reviewCount: 567,
    ),
  ];

  ItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth ~/ 200);
    double childAspectRatio = 0.60;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: products.map((product) {
        return Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "-${product.discount}%",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemPage(product: product),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Center(
                    child: Image.asset(
                      product.image,
                      height: 120,
                      width: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Text(
                product.title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4C53A5),
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Text(
                  product.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${product.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')} đ",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const Text(
                      "Đã bán 2.5k",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
