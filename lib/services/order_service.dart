import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(OrderModel order) async {
    await _firestore.collection('orders').add({
      'customerName': order.customerName,
      'mobile': order.mobile,
      'address': order.address,
      'totalAmount': order.totalAmount,
      'orderDate': order.orderDate,
      'status': order.status,
      'items': order.items,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
