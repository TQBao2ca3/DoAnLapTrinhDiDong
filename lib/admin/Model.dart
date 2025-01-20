class OrderDetail {
  final String name;
  final int quantity;
  final String storage;
  final double? price;
  final double? total;

  OrderDetail({
    required this.name,
    required this.quantity,
    required this.storage,
    this.price,
    this.total,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      name: json['name'] ?? 'Unknown',
      quantity: json['quantity'] ?? 0,
      storage: json['storage'] ?? '0',
      price: (json['price'] != null) ? double.parse(json['price'].toString()) : null,
      total: (json['total'] != null) ? double.parse(json['total'].toString()) : null,
    );
  }
}

class Order {
  final String id;
  final List<String> orderIds;
  final String customerName;
  final String phone;
  final List<String> imageUrls;
  final List<int> statuses;
  final List<String> dates;
  final double total;
  final List<OrderDetail> products;

  Order({
    required this.id,
    required this.orderIds,
    required this.customerName,
    required this.phone,
    required this.imageUrls,
    required this.statuses,
    required this.dates,
    required this.total,
    this.products = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      // Chuyển đổi order_ids thành List
      orderIds: json['order_ids'] is String
          ? [json['order_ids']]
          : List<String>.from(json['order_ids'] ?? []),
      customerName: json['customerName'] ?? '',
      phone: json['phone'] ?? '',
      // Chuyển đổi image_url thành List
      imageUrls: json['image_url'] is String
          ? [json['image_url']]
          : List<String>.from(json['image_url'] ?? []),
      // Chuyển đổi status thành List
      statuses: json['status'] is int
          ? [json['status']]
          : List<int>.from(json['status'] ?? []),
      // Chuyển đổi date thành List
      dates: json['date'] is String
          ? [json['date']]
          : List<String>.from(json['date'] ?? []),
      total: double.parse(json['total'].toString()),
      products: (json['products'] as List?)
          ?.map((item) => OrderDetail.fromJson(item))
          .toList() ?? [],
    );
  }
}