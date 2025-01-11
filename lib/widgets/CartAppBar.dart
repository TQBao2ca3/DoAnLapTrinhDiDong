import 'package:flutter/material.dart';

class CartAppBar extends StatelessWidget {
  final int itemCount;
  const CartAppBar({super.key, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Color(0xFF4C53A5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                const Text(
                  "Giỏ hàng",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 20, 173, 161),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    itemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
