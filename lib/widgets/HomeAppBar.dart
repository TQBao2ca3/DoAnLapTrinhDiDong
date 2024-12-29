import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final String tooltipMessage; 

  HomeAppBar({Key? key, required this.tooltipMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue,
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          Icon(
            Icons.sort,
            size: 30,
            color: Color(0xFF4C53A5),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Phone Shop",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 225, 214, 4),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "You're King In Your Way !!",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, 
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Stack(
            children: [
              Tooltip(
                message: tooltipMessage,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "cartPage");
                  },
                  child: const Icon(
                    Icons.shopping_cart,
                    size: 35,
                    color: Color.fromARGB(255, 216, 223, 19),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 13, 
                  height: 13,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 206, 79, 70),
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
