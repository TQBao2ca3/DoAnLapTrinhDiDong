import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phoneshop/models/Cart.dart';
import 'package:phoneshop/models/Product.dart';
import 'package:phoneshop/pages/CartPage.dart';
import 'package:phoneshop/pages/PaymentPage.dart';

class ItemPage extends StatefulWidget {
  final Product product;

  const ItemPage({super.key, required this.product});

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  int _selectedImageIndex = 0;
  String _selectedStorage = '128GB';
  String _selectedColor = 'Đen';
  PageController _pageController = PageController();
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
            size: 30,
            color: Color(0xFF4C53A5),),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Chi tiết sản phẩm",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlue,
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              // Product Images Carousel
              SizedBox(
                height: 300,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 4,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedImageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Image.asset(widget.product.image);
                  },
                ),
              ),

              // Thumbnail Images
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    4,
                        (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImageIndex = index;
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedImageIndex == index
                                ? Colors.blue
                                : Colors.grey.shade300,
                            width: _selectedImageIndex == index ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          widget.product.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Price, Favorite and Sold Count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "đ${widget.product.price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        if (widget.product.discount > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "-${widget.product.discount}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Đã bán 2k",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isFavorite = !_isFavorite;
                            });
                          },
                          child: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Storage Options
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Màu sắc",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (String colors in widget.product.colors)
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ChoiceChip(
                              label: Text(colors),
                              selected: _selectedColor == colors,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedColor = colors;
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // Storage Options
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dung lượng",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (String storage in widget.product.storage)
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ChoiceChip(
                              label: Text(storage),
                              selected: _selectedStorage == storage,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedStorage = storage;
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // Description and Manufacturing Date
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Thông tin sản phẩm",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            "Ngày sản xuất: ${widget.product.createAt.day}/${widget.product.createAt.month}/${widget.product.createAt.year}",
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Mô tả sản phẩm",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.description,
                      style: const TextStyle(color: Colors.grey, height: 1.5),
                    ),
                  ],
                ),
              ),
              // Title and Rating
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        Text(
                          " ${widget.product.rating}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(" (${widget.product.reviewCount} đánh giá)"),
                      ],
                    ),
                  ],
                ),
              ),

              // Description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Mô tả sản phẩm",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.product.description,
                  style: const TextStyle(color: Colors.grey, height: 1.5),
                ),
              ),

              // Bottom padding for buttons
              const SizedBox(height: 80),
            ],
          ),

          // Fixed bottom buttons
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Tạo một sản phẩm mới với storage đã chọn
                        Product productToAdd = Product(
                          id: widget.product.id,
                          title: widget.product.title,
                          description: widget.product.description,
                          image: widget.product.image,
                          price: widget.product.price,
                          originalPrice: widget.product.originalPrice,
                          discount: widget.product.discount,
                          storage: widget.product.storage,
                          colors: [_selectedColor], // Chuyển String thành List<String> bằng cách đặt trong []
                          createAt: widget.product.createAt,
                          quantity: 1,
                        );

                        // Thêm sản phẩm vào giỏ hàng
                        final cart = Cart();
                        cart.add(productToAdd);

                        // Hiển thị dialog xác nhận
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Thông báo"),
                              content: Text(
                                  'Sản phẩm "${widget.product.title}" với màu $_selectedColor và dung lượng $_selectedStorage đã được thêm vào giỏ hàng.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Đóng dialog
                                  },
                                  child: const Text("Đóng"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Đóng dialog
                                    // Chuyển đến trang giỏ hàng
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CartPage(cart: cart),
                                      ),
                                    );
                                  },
                                  child: const Text("Đến giỏ hàng"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.shopping_cart, color: Colors.white), // Icon trước chữ
                      label: const Text("Thêm vào giỏ hàng"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Buy with Voucher Button
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: () {
                        // Chuyển sang trang thanh toán
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PaymentPage(cartItems: [], totalAmount: 0,)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Mua hàng",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}