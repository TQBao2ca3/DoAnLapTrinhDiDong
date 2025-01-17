import 'package:flutter/material.dart';
import 'package:phoneshop/pages/UserInformation.dart';
import 'package:phoneshop/pages/userAuthentication.dart';
import 'package:phoneshop/providers/user_provider.dart'; // Make sure this path is correct
import 'package:phoneshop/services/userPreference.dart';
import 'package:phoneshop/widgets/Product_Order_Page.dart';
import 'package:provider/provider.dart';

class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final userId = userProvider.userId;
        print('Current userId in Screen3: $userId'); // Debug print

        return Scaffold(
          backgroundColor: Colors.blue,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(''),
            backgroundColor: Colors.blue,
            actions: [
              IconButton(
                onPressed: () async {
                  await Future.wait([
                    UserPreferences.removeToken(),
                    UserPreferences.removeUserId(),
                  ]);

                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserAuthentication(),
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 25, left: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Tra cứu thông tin",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      // User Information Button
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 40,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserInformation(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 80),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            shadowColor: Colors.black,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
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
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Order History Button
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 40,
                        ),
                        child: ElevatedButton(
                          onPressed: userId != null
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductOrderScreen(
                                        userId: userId,
                                      ),
                                    ),
                                  );
                                }
                              : null, // Button will be disabled if userId is null
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 80),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            shadowColor: Colors.black,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
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
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
