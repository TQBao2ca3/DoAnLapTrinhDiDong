// Trong Model.dart
class OrderDetail {
  final String name;
  final int quantity;
  final String storage;
  final double? price;  // Có thể null
  final double? total;  // Có thể null

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
      storage: json['storage'] ?? 0,
      price: (json['price'] != null) ? double.parse(json['price'].toString()) : null,
      total: (json['total'] != null) ? double.parse(json['total'].toString()) : null,
    );
  }
}
class Order {
  final String id;
  final String customerName;
  final String phone;
  final double total;
  final int status;
  final String date;

  Order({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.total,
    required this.status,
    required this.date,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      customerName: json['customerName'],
      phone: json['phone'],
      total: json['total'].toDouble(),
      status: json['status'],
      date: json['date'],
    );
  }
}