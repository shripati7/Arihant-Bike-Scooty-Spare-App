class OrderModel {
  final String customerName;
  final String mobile;
  final String address;
  final double totalAmount;
  final String orderDate;

  OrderModel({
    required this.customerName,
    required this.mobile,
    required this.address,
    required this.totalAmount,
    required this.orderDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'mobile': mobile,
      'address': address,
      'totalAmount': totalAmount,
      'orderDate': orderDate,
    };
  }
}
