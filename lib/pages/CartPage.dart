  import 'package:flutter/material.dart';
  import 'package:phoneshop/models/Cart.dart';
import 'package:phoneshop/models/CartItem.dart';
  import 'package:phoneshop/models/Product.dart';
  import 'package:phoneshop/pages/PaymentPage.dart';
  import 'package:phoneshop/widgets/CartAppBar.dart';
  import 'package:intl/intl.dart';

  class CartPage extends StatefulWidget {
    final Cart cart;
    const CartPage({super.key, required this.cart});

    @override
    _CartPageState createState() => _CartPageState();
  }

  class _CartPageState extends State<CartPage> {
    final List<int> _selectedProductIndices = [];
    bool _selectAll = false;
    List<CartItem> getSelectedItems() {
      List<CartItem> selectedItems = [];
      for (int index in _selectedProductIndices) {
        Product product = widget.cart.items[index];
        selectedItems.add(CartItem.fromProduct(product));
      }
      return selectedItems;
    }
    void _toggleProductSelection(int index) {
      setState(() {
        if (_selectedProductIndices.contains(index)) {
          _selectedProductIndices.remove(index);
        } else {
          _selectedProductIndices.add(index);
        }
        _updateSelectAllState();
      });
    }

    void _toggleSelectAll() {
      setState(() {
        if (_selectAll) {
          _selectedProductIndices.clear();
        } else {
          _selectedProductIndices.addAll(
            List.generate(widget.cart.items.length, (index) => index),
          );
        }
        _selectAll = !_selectAll;
      });
    }

    void _updateSelectAllState() {
      setState(() {
        _selectAll = _selectedProductIndices.length == widget.cart.items.length;
      });
    }

    String _formatCurrency(int amount) {
      final formatCurrency = NumberFormat('#,##0 đ', 'vi_VN');
      return formatCurrency.format(amount);
    }

    int _calculateTotalAmount() {
      int total = 0;
      for (var product in widget.cart.items) {
        if (_selectedProductIndices.contains(widget.cart.items.indexOf(product))) {
          total += product.price.toInt() * product.quantity.toInt(); // Nếu `price` hoặc `quantity` là double

        }
      }
      return total;
    }
    @override
    Widget build(BuildContext context) {
      List<Product> cartItems = widget.cart.items;
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CartAppBar(itemCount: cartItems.length),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 15),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDECF2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: cartItems.isEmpty
                      ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Text(
                        "Giỏ hàng của bạn đang trống.",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      Product product = cartItems[index];
                      int totalPrice = product.price.toInt() * product.quantity;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: SizedBox(
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
                              Text(
                                "Màu sắc: ${product.colors.first}", // Lấy phần tử đầu tiên của List
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          // Thêm nút xóa
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Xác nhận xóa'),
                                  content: const Text('Bạn có chắc muốn xóa sản phẩm này?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Hủy'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.cart.items.removeAt(index);
                                          if (_selectedProductIndices.contains(index)) {
                                            _selectedProductIndices.remove(index);
                                          }
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Xóa'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatCurrency(totalPrice),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (product.quantity > 1) {
                                          product.quantity--;
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.remove_circle_outline),
                                  ),
                                  Text(product.quantity.toString()),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        product.quantity++;
                                      });
                                    },
                                    icon: const Icon(Icons.add_circle_outline),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, -1),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _selectAll,
                          onChanged: (bool? value) {
                            _toggleSelectAll();
                          },
                        ),
                        const Text("Chọn tất cả"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tổng thanh toán: ${_formatCurrency(_calculateTotalAmount())}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_selectedProductIndices.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Thông báo"),
                                      content: const Text("Vui lòng chọn ít nhất một sản phẩm để thanh toán."),
                                      actions: [
                                        TextButton(
                                          child: const Text("Đóng"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                // Lấy danh sách sản phẩm đã chọn
                                List<CartItem> selectedItems = getSelectedItems();
                                int totalAmount = selectedItems.fold(0, (sum, item) => sum + item.totalPrice);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentPage(
                                      cartItems: selectedItems,
                                      totalAmount: totalAmount,
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text("Mua hàng",
                            style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
