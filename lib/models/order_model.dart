class OrderModel {
  final String? id;
  final String customerName;
  final String mobile;
  final String address;
  final String pinCode;
  final String orderDate;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String status;

  OrderModel({
    this.id,
    required this.customerName,
    required this.mobile,
    required this.address,
    required this.pinCode,
    required this.orderDate,
    required this.items,
    required this.totalAmount,
    this.status = "Pending",
  });

  factory OrderModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return OrderModel(
      id: documentId,
      customerName: map["customerName"] ?? "",
      mobile: map["mobile"] ?? "",
      address: map["address"] ?? "",
      pinCode: map["pinCode"] ?? "",
      orderDate: map["orderDate"] ?? "",
      items: List<Map<String, dynamic>>.from(
        map["items"] ?? [],
      ),
      totalAmount: (map["totalAmount"] ?? 0).toDouble(),
      status: map["status"] ?? "Pending",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "customerName": customerName,
      "mobile": mobile,
      "address": address,
      "pinCode": pinCode,
      "orderDate": orderDate,
      "items": items,
      "totalAmount": totalAmount,
      "status": status,
    };
  }

  OrderModel copyWith({
    String? id,
    String? customerName,
    String? mobile,
    String? address,
    String? pinCode,
    String? orderDate,
    List<Map<String, dynamic>>? items,
    double? totalAmount,
    String? status,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
      pinCode: pinCode ?? this.pinCode,
      orderDate: orderDate ?? this.orderDate,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
    );
  }
}
