import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoneshop/models/Cart.dart';
import 'package:phoneshop/models/Product.dart';
import 'package:phoneshop/widgets/ItemAppBar.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ItemPage extends StatefulWidget {
  final Product product;

  const ItemPage({super.key, required this.product});

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  int _quantity = 1;
  String _selectedSize = '39';

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double price = widget.product.price.toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFEDECF2),
      body: ListView(
        children: [
          const ItemAppBar(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Image.asset(widget.product.image, height: 300),
          ),
          Arc(
            edge: Edge.TOP,
            arcType: ArcType.CONVEX,
            height: 30,
            child: Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 223, 220, 220),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 20),
                      child: Row(
                        children: [
                          Text(
                            widget.product.title,
                            style: const TextStyle(
                              fontSize: 28,
                              color: Color(0xFF4C53A5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 10),
                      child: Text(
                        widget.product.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RatingBar.builder(
                            initialRating: 5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemSize: 20,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 245, 241, 2),
                            ),
                            onRatingUpdate: (index) {},
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: _decrementQuantity,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 193, 14, 14)
                                            .withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.minus,
                                    size: 18,
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  _quantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _incrementQuantity,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 193, 14, 14)
                                            .withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.plus,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Size:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DropdownButton<String>(
                            value: _selectedSize,
                            items: ['39', '40', '41', '42'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedSize = newValue!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${(price * _quantity).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')} đ",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Product productToAdd = Product(
                                title: widget.product.title,
                                description: widget.product.description,
                                image: widget.product.image,
                                price: widget.product.price,
                                discount: widget.product.discount,
                                quantity: _quantity,
                                size: _selectedSize,
                              );
                              Cart cart = Cart();
                              cart.add(productToAdd);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${productToAdd.title} (Size $_selectedSize) đã được thêm vào giỏ hàng với số lượng $_quantity!'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(CupertinoIcons.cart_badge_plus),
                            label: const Text(
                              "Thêm vào giỏ hàng",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                const Color.fromARGB(255, 14, 166, 243),
                              ),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 13, horizontal: 15),
                              ),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
