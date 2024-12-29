import 'package:flutter/material.dart';
import 'package:phoneshop/models/Cart.dart';
import 'package:phoneshop/models/Product.dart';
import 'package:phoneshop/widgets/CartAppBar.dart';
import 'package:phoneshop/widgets/CartBottomNavBar.dart';
import 'package:intl/intl.dart'; 

class CartPage extends StatefulWidget {
  final Cart cart;

  CartPage({Key? key, required this.cart}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<int> _selectedProductIndices = [];

  void _toggleProductSelection(int index) {
    setState(() {
      if (_selectedProductIndices.contains(index)) {
        _selectedProductIndices.remove(index);
      } else {
        _selectedProductIndices.add(index);
      }
    });
  }

  void _incrementQuantity(int index) {
    setState(() {
      widget.cart.items[index].quantity++;
    });
  }

  void _decrementQuantity(int index) {
    if (widget.cart.items[index].quantity > 1) {
      setState(() {
        widget.cart.items[index].quantity--;
      });
    }
  }

  void _removeProduct(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận xóa"),
          content: Text("Bạn có chắc chắn muốn xóa sản phẩm này không?"),
          actions: [
            TextButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: Text("Xóa"),
              onPressed: () {
                setState(() {
                  widget.cart.items.removeAt(index);
                  _selectedProductIndices.remove(index); 
                });
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
  }

  String _formatCurrency(double amount) {
    final formatCurrency = NumberFormat('#,##0 đ', 'vi_VN');
    return formatCurrency.format(amount);
  }

  double _calculateTotalAmount() {
    double total = 0.0;
    for (var product in widget.cart.items) {
      total += product.price * product.quantity;
    }
    return total;
  }
  @override
  Widget build(BuildContext context) {
    List<Product> cartItems = widget.cart.items;
    return Scaffold(
      body: SafeArea(  // Thêm SafeArea để tránh tràn notch
        child: Column(
          children: [
            CartAppBar(itemCount: cartItems.length),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  color: Color(0xFFEDECF2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: cartItems.isEmpty
                    ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      "Giỏ hàng của bạn đang trống.",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
                    : ListView.builder(
                  padding: EdgeInsets.only(bottom: 80), // Thêm padding bottom để tránh bị che bởi CartBottomNavBar
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    Product product = cartItems[index];
                    double totalPrice = product.price.toDouble() * product.quantity;

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        leading: Container( // Wrap Row trong Container với width cố định
                          width: 120,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: _selectedProductIndices.contains(index),
                                onChanged: (bool? value) {
                                  _toggleProductSelection(index);
                                },
                              ),
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: Image.asset(product.image),
                              ),
                            ],
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text("Size: ${product.size}"),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatCurrency(totalPrice),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () => _decrementQuantity(index),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text("${product.quantity}"),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () => _incrementQuantity(index),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeProduct(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            CartBottomNavBar(totalAmount: _calculateTotalAmount()),
          ],
        ),
      ),
    );
  }
}