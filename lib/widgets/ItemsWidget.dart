import 'package:flutter/material.dart';
import 'package:phoneshop/models/Product.dart';
import 'package:phoneshop/pages/ItemPage.dart';

class ItemsWidget extends StatelessWidget {
  final List<Product> products = [
    Product(
      title: "iPhone 16 Pro Max 256GB",
      description:
          "iPhone 16 Pro Max sở hữu màn hình 6.9 inch với công nghệ ProMotion, mang lại trải nghiệm hiển thị mượt mà và sắc nét, lý tưởng cho giải trí và làm việc.",
      image: "assets/images/1.png",
      price: 33990000,
      discount: 10,
    ),
    Product(
      title: "ADIDAS SPIRITAIN 2.0",
      description:
          "Giày chạy ADIDAS SPIRITAIN 2.0 mang phong cách năng động thể thao, thời thượng đa màu sắc.",
      image: "assets/images/2.png",
      price: 2500000,
      discount: 15,
    ),
    Product(
      title: "JORDAN 1 HI CO JAPAN MIDNIGHT NAVY",
      description:
          "Giày JORDAN 1 HI CO JAPAN MIDNIGHT NAVY là một trong những đôi giày được săn đón nhất hiện nay với phong cách trẻ trung và năng động.",
      image: "assets/images/3.png",
      price: 10500000,
      discount: 5,
    ),
    Product(
      title: "AIR JORDAN 1 HIGH OG",
      description:
          "AIR JORDAN 1 HIGH OG là một đôi giày đẹp nhất, trẻ trung và dễ dàng phối với nhiều trang phục khác nhau.",
      image: "assets/images/4.png",
      price: 9500000,
      discount: 5,
    ),
    Product(
      title: "NIKE AIR MAX 1 SHIMA SHIMA",
      description:
          "Giày NIKE AIR MAX 1 SHIMA SHIMA mang phong cách tối giản nhưng vẫn đậm chất thể thao, phù hợp với những ai yêu thích sự thoải mái và phong cách.",
      image: "assets/images/5.png",
      price: 3200000,
      discount: 10,
    ),
    Product(
      title: "NIKE PEGASUS 40",
      description:
          "NIKE PEGASUS 40 có phong cách thiết kế độc đáo thu hút mọi ánh nhìn, được trang bị công nghệ đệm tiên tiến, đem lại sự thoải mái tối ưu khi chạy.",
      image: "assets/images/6.png",
      price: 2900000,
      discount: 3,
    ),
    Product(
      title: "YEEZY BOOST 350 V2",
      description:
          "Giày YEEZY BOOST 350 V2 mang lại sự kết hợp hoàn hảo giữa phong cách thời trang và tính năng thoải mái vượt trội, phù hợp cho mọi hoàn cảnh.",
      image: "assets/images/7.png",
      price: 5500000,
      discount: 5,
    ),
    Product(
      title: "YEEZY BOOST 350 PIRATE BLACK",
      description:
          "YEEZY BOOST 350 PIRATE BLACK là đôi giày được yêu thích với phong cách mạnh mẽ và gam màu đen chủ đạo, tạo nên sự ấn tượng không thể chối từ.",
      image: "assets/images/8.png",
      price: 15000000,
      discount: 8,
    ),
    Product(
      title: "YEEZY BOOST 700 V2 STATIC",
      description:
          "Giày YEEZY BOOST 700 V2 STATIC có thiết kế hầm hố và sang trọng, kết hợp với sự thoải mái tuyệt vời, là sự lựa chọn hoàn hảo cho những người yêu thích phong cách đường phố.",
      image: "assets/images/9.png",
      price: 12000000,
      discount: 6,
    ),
    Product(
      title: "YEEZY SLIDE DARK ONYX",
      description:
          "YEEZY SLIDE DARK ONYX là đôi dép đơn giản nhưng không kém phần nổi bật, với thiết kế mềm mại và tông màu đen mạnh mẽ, lý tưởng cho những ngày thư giãn.",
      image: "assets/images/10.png",
      price: 3600000,
      discount: 5,
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
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Text(
                  product.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  maxLines: 2,
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
                      "Đã bán 15,2k",
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
