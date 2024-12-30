import 'package:flutter/material.dart';

class CartAppBar extends StatelessWidget {
  final int itemCount; 
  CartAppBar({Key? key, required this.itemCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: Color(0xFF4C53A5),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Text(
                  "Giỏ hàng",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                   color: Colors.lightBlue,
                  ),
                ),
                SizedBox(width: 5), 
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 20, 173, 161), 
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    itemCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Icon(
            Icons.more_vert,
            size: 30,
            color: Color(0xFF4C53A5),
          ),
        ],
      ),
    );
  }
}
