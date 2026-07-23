class OrderModel {
  final String customerName;
  final String mobile;
  final String address;
  final double totalAmount;
  final String orderDate;

  final String status;
  final List<Map<String, dynamic>> items;

  OrderModel({
    required this.customerName,
    required this.mobile,
    required this.address,
    required this.totalAmount,
    required this.orderDate,
    required this.items,
    this.status = "Pending",
  });

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'mobile': mobile,
      'address': address,
      'totalAmount': totalAmount,
      'orderDate': orderDate,
      'status': status,
      'items': items,
    };
  }
}
