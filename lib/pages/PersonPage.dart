import 'package:flutter/material.dart';
import 'package:phoneshop/pages/UserInformation.dart';
import 'package:phoneshop/providers/User_Provider.dart';
import 'package:phoneshop/widgets/Product_Order_Page.dart';
import 'package:provider/provider.dart';

class Screen3 extends StatelessWidget {
  const Screen3({super.key});
  @override
  Widget build(BuildContext context) {
    final user_id = context.watch<UserProvider>().userId;
    return Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(''),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            children: [
              const Padding(
                  padding: EdgeInsets.only(top: 25, left: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Tra cứu thông tin",
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                    ),
                  )),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserInformation()));
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 80),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            shadowColor: Colors.black,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.account_box),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  "Thông tin cá nhân",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      color: Colors.black),
                                ),
                              )
                            ],
                          )),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductOrderScreen(
                                          userId: user_id,
                                        )));
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 80),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            shadowColor: Colors.black,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.list_alt),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  "Đơn hàng",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      color: Colors.black),
                                ),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
