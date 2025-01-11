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
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Column(
            children: [
              // Custom AppBar với thiết kế mới
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Giỏ hàng (${cartItems.length})',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: cartItems.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: Colors.blue[200],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Giỏ hàng của bạn đang trống",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Hãy thêm sản phẩm vào giỏ hàng",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    Product product = cartItems[index];
                    int totalPrice = product.price.toInt() * product.quantity;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Delete Button
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red[400],
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Row(
                                      children: [
                                        Icon(Icons.warning, color: Colors.orange[700]),
                                        const SizedBox(width: 8),
                                        const Text('Xác nhận xóa'),
                                      ],
                                    ),
                                    content: const Text('Bạn có chắc muốn xóa sản phẩm này?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          'Hủy',
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.cart.items.removeAt(index);
                                            if (_selectedProductIndices.contains(index)) {
                                              _selectedProductIndices.remove(index);
                                            }
                                          });
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[400],
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          'Xóa',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          // Main Content
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Checkbox
                                Transform.scale(
                                  scale: 1.2,
                                  child: Checkbox(
                                    value: _selectedProductIndices.contains(index),
                                    activeColor: Colors.blue[600],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (bool? value) {
                                      _toggleProductSelection(index);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Product Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    product.image,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Product Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Màu sắc: ${product.colors.first}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _formatCurrency(totalPrice),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      // Quantity Controls
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              icon: Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.blue[700],
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  if (product.quantity > 1) {
                                                    product.quantity--;
                                                  }
                                                });
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              child: Text(
                                                product.quantity.toString(),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              icon: Icon(
                                                Icons.add_circle_outline,
                                                color: Colors.blue[700],
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  product.quantity++;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Select All Row
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              value: _selectAll,
                              activeColor: Colors.blue[600],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (bool? value) {
                                _toggleSelectAll();
                              },
                            ),
                          ),
                          const Text(
                            "Chọn tất cả",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Total and Checkout Button
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Tổng thanh toán",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatCurrency(_calculateTotalAmount()),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 160,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_selectedProductIndices.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: Row(
                                        children: [
                                          Icon(Icons.info_outline, color: Colors.blue[600]),
                                          const SizedBox(width: 8),
                                          const Text("Thông báo"),
                                        ],
                                      ),
                                      content: const Text(
                                        "Vui lòng chọn ít nhất một sản phẩm để thanh toán.",
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(context),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue[600],
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text(
                                            "Đóng",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  List<CartItem> selectedItems = getSelectedItems();
                                  int totalAmount = selectedItems.fold(
                                    0,
                                        (sum, item) => sum + item.totalPrice,
                                  );

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
                                backgroundColor: Colors.blue[600],
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                "Mua hàng",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }