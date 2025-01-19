import 'package:flutter/material.dart';
import 'package:phoneshop/pages/CartPage.dart';

class HomeAppBar extends StatelessWidget {
  final String tooltipMessage;

  const HomeAppBar({
    super.key,
    required this.tooltipMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.sort,
            size: 25,
            color: Color(0xFF4C53A5),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "H2DB Mobile",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 225, 214, 4),
                  ),
                ),
                Text(
                  "You're King In Your Way !!",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Tooltip(
                message: tooltipMessage,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CartPage() // Sử dụng biến cart
                            ));
                  },
                  child: const Icon(
                    Icons.shopping_cart,
                    size: 28,
                    color: Color.fromARGB(
                        255, 216, 223, 19), // Đổi màu về màu vàng
                  ),
                ),
              ),
              Positioned(
                right: -5,
                top: -5,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 206, 79, 70),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
