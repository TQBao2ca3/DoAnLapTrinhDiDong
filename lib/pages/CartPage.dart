import 'package:flutter/material.dart';
import 'package:phoneshop/models/CartItem.dart';
import 'package:phoneshop/models/Product.dart';
import 'package:phoneshop/pages/PaymentPage.dart';
import 'package:intl/intl.dart';
import 'package:phoneshop/providers/CartItems_Provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<int> _selectedProductIndices = [];
  bool _selectAll = false;

  List<CartItem> getSelectedItems() {
    final cartProvider = context.read<CartProvider>();
    List<CartItem> selectedItems = [];
    for (int index in _selectedProductIndices) {
      CartItem cartItem = cartProvider.items[index];
      // Tạo một CartItem mới với các thuộc tính từ cartItem hiện có
      selectedItems.add(CartItem(
        cart_id: cartItem.cart_id,
        cart_item_id: cartItem.cart_item_id,
        description: cartItem.description,
        price: cartItem.price,
        quantity: cartItem.quantity,
        image_url: cartItem.image_url,
        colors: cartItem.colors,
        storage: cartItem.storage,
        storeName: 'Phone Shop',
      ));
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
    final cartProvider = context.read<CartProvider>();
    setState(() {
      if (_selectAll) {
        _selectedProductIndices.clear();
      } else {
        _selectedProductIndices.addAll(
          List.generate(cartProvider.items.length, (index) => index),
        );
      }
      _selectAll = !_selectAll;
    });
  }

  void _updateSelectAllState() {
    final cartProvider = context.read<CartProvider>();
    setState(() {
      _selectAll = _selectedProductIndices.length == cartProvider.items.length;
    });
  }

  String _formatCurrency(double amount) {
    final formatCurrency = NumberFormat('#,##0 đ', 'vi_VN');
    return formatCurrency.format(amount);
  }

  double _calculateTotalAmount() {
    final cartProvider = context.read<CartProvider>();
    double total = 0;
    for (var cartItem in cartProvider.items) {
      if (_selectedProductIndices
          .contains(cartProvider.items.indexOf(cartItem))) {
        total += cartItem.price * cartItem.quantity;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        List<CartItem> cartItems = cartProvider.items;
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
                            CartItem cartItem = cartItems[index];
                            double totalPrice =
                                cartItem.price * cartItem.quantity.toDouble();

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
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            title: Row(
                                              children: [
                                                Icon(Icons.warning,
                                                    color: Colors.orange[700]),
                                                const SizedBox(width: 8),
                                                const Text('Xác nhận xóa'),
                                              ],
                                            ),
                                            content: const Text(
                                                'Bạn có chắc muốn xóa sản phẩm này?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text(
                                                  'Hủy',
                                                  style: TextStyle(
                                                      color: Colors.grey[600]),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  cartProvider.remove(cartItem);
                                                  if (_selectedProductIndices
                                                      .contains(index)) {
                                                    _selectedProductIndices
                                                        .remove(index);
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.red[400],
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Xóa',
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Checkbox
                                        Transform.scale(
                                          scale: 1.2,
                                          child: Checkbox(
                                            value: _selectedProductIndices
                                                .contains(index),
                                            activeColor: Colors.blue[600],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            onChanged: (bool? value) {
                                              _toggleProductSelection(index);
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 8),

                                        // Product Image
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(
                                            cartItem.image_url,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 16),

                                        // Product Details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cartItem.description,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Màu sắc: ${cartItem.colors}, ${cartItem.storage}",
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          const BoxConstraints(),
                                                      icon: Icon(
                                                        Icons
                                                            .remove_circle_outline,
                                                        color: Colors.blue[700],
                                                      ),
                                                      onPressed: () {
                                                        if (cartItem.quantity >
                                                            1) {
                                                          cartProvider
                                                              .updateQuantity(
                                                                  cartItem,
                                                                  cartItem.quantity -
                                                                      1);
                                                        }
                                                      },
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12),
                                                      child: Text(
                                                        cartItem.quantity
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          const BoxConstraints(),
                                                      icon: Icon(
                                                        Icons
                                                            .add_circle_outline,
                                                        color: Colors.blue[700],
                                                      ),
                                                      onPressed: () {
                                                        cartProvider
                                                            .updateQuantity(
                                                                cartItem,
                                                                cartItem.quantity +
                                                                    1);
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        title: Row(
                                          children: [
                                            Icon(Icons.info_outline,
                                                color: Colors.blue[600]),
                                            const SizedBox(width: 8),
                                            const Text("Thông báo"),
                                          ],
                                        ),
                                        content: const Text(
                                          "Vui lòng chọn ít nhất một sản phẩm để thanh toán.",
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue[600],
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text(
                                              "Đóng",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    List<CartItem> selectedItems =
                                        getSelectedItems();
                                    double totalAmount =
                                        _calculateTotalAmount();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentPage(
                                          cartItems: selectedItems,
                                          totalAmount: totalAmount.toInt(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[600],
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
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
      },
    );
  }
}
