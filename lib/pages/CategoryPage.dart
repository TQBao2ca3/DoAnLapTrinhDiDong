import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phoneshop/widgets/ItemsWidget.dart';

class CategoryPage extends StatefulWidget {
  final String searchQuery;

  const CategoryPage({
    super.key,
    this.searchQuery = '',
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  RangeValues _currentRangeValues = const RangeValues(400000, 485000000);
  String? selectedPriceRange;
  String? selectedCategory;
  double? minPrice;
  double? maxPrice;

  Widget categoryItem(BuildContext context, String name, String imagePath) {
    bool isSelected = selectedCategory == name;
    return InkWell(
      onTap: () {
        setState(() {
          selectedCategory = isSelected ? null : name;
        });
      },
      child: Container(
        width: 70,
        decoration: BoxDecoration(
          border: isSelected ? Border.all(color: Colors.lightBlue, width: 2) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
              child: Container(
                width: 45,
                height: 45,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              height: 16,
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.lightBlue : Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(num amount) {
    final formatCurrency = NumberFormat('#,##0 đ', 'vi_VN');
    return formatCurrency.format(amount);
  }

  void _showFilterDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Bộ lọc tìm kiếm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Khoảng Giá',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatCurrency(_currentRangeValues.start),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                _formatCurrency(_currentRangeValues.end),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          RangeSlider(
                            values: _currentRangeValues,
                            min: 400000,
                            max: 485000000,
                            divisions: 100,
                            activeColor: Colors.lightBlue,
                            inactiveColor: Colors.lightBlue.withOpacity(0.2),
                            onChanged: (RangeValues values) {
                              setState(() {
                                _currentRangeValues = values;
                                selectedPriceRange = null;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Chọn nhanh',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _buildFilterChip('Dưới 1 triệu', 'under1m', setState),
                              _buildFilterChip('1 - 3 triệu', '1to3m', setState),
                              _buildFilterChip('3 - 5 triệu', '3to5m', setState),
                              _buildFilterChip('5 - 10 triệu', '5to10m', setState),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _currentRangeValues = const RangeValues(400000, 485000000);
                                selectedPriceRange = null;
                                minPrice = null;
                                maxPrice = null;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              side: const BorderSide(color: Colors.lightBlue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Đặt lại',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              this.setState(() {
                                minPrice = _currentRangeValues.start;
                                maxPrice = _currentRangeValues.end;
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Áp dụng',
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
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(String label, String value, StateSetter setState) {
    bool isSelected = selectedPriceRange == value;
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      onSelected: (bool selected) {
        setState(() {
          selectedPriceRange = selected ? value : null;
          switch(value) {
            case 'under1m':
              _currentRangeValues = const RangeValues(400000, 1000000);
              break;
            case '1to3m':
              _currentRangeValues = const RangeValues(1000000, 3000000);
              break;
            case '3to5m':
              _currentRangeValues = const RangeValues(3000000, 5000000);
              break;
            case '5to10m':
              _currentRangeValues = const RangeValues(5000000, 10000000);
              break;
          }
        });
      },
      selectedColor: Colors.lightBlue.withOpacity(0.2),
      checkmarkColor: Colors.lightBlue,
      backgroundColor: Colors.grey.withOpacity(0.1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECF2),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Danh Mục Sản Phẩm",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                  ),
                ),
                IconButton(
                  onPressed: () => _showFilterDrawer(context),
                  icon: const Icon(
                    Icons.filter_list,
                    color: Colors.lightBlue,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 80,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    categoryItem(context, "iPhone", "assets/images/1.png"),
                    categoryItem(context, "Samsung", "assets/images/2.png"),
                    categoryItem(context, "Oppo", "assets/images/3.png"),
                    categoryItem(context, "Redmi", "assets/images/10.png"),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                ItemsWidget(
                  searchQuery: widget.searchQuery,
                  selectedCategory: selectedCategory,
                  minPrice: minPrice,
                  maxPrice: maxPrice,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}