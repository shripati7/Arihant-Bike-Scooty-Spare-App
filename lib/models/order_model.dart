class OrderModel {
  final String? id;

  /// Firebase User UID
  final String userId;

  final String customerName;
  final String mobile;
  final String address;

  final double totalAmount;

  final String orderDate;

  final String status;

  final List<Map<String, dynamic>> items;

  OrderModel({
    this.id,
    required this.userId,
    required this.customerName,
    required this.mobile,
    required this.address,
    required this.totalAmount,
    required this.orderDate,
    required this.items,
    this.status = 'Pending',
  });
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'customerName': customerName,
      'mobile': mobile,
      'address': address,
      'totalAmount': totalAmount,
      'orderDate': orderDate,
      'status': status,
      'items': items,
    };
  }

  factory OrderModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return OrderModel(
      id: documentId,
      userId: map['userId'] ?? '',
      customerName: map['customerName'] ?? '',
      mobile: map['mobile'] ?? '',
      address: map['address'] ?? '',
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      orderDate: map['orderDate'] ?? '',
      status: map['status'] ?? 'Pending',
      items: List<Map<String, dynamic>>.from(
        map['items'] ?? [],
      ),
    );
  }
}
