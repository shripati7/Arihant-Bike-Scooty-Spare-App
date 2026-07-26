import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(OrderModel order) async {
    await _firestore.collection('orders').add(order.toMap());
  }

  Future<List<OrderModel>> getOrders() async {
    final snapshot = await _firestore
        .collection('orders')
        .orderBy('orderDate', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();

    if (!doc.exists) {
      return null;
    }

    return OrderModel.fromMap(doc.data()!, doc.id);
  }

  Future<void> deleteOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).delete();
  }
}
