import 'package:flutter/material.dart';

class ItemAppBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(25),
      child: Row(children: [
        InkWell(
          onTap: (){
          Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color:  Color(0xFF4C53A5),
            ),
         
        ),
        Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Sản Phẩm",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue
              ),
              ),
              ),
              Spacer(),
              Icon(
                Icons.favorite,
                size: 30,
                color:Colors.red,
              )
      ],),
    );
  }
}