import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/order_model.dart';

class OrderService {
  OrderService._();

  static final OrderService instance = OrderService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _orders =>
      _firestore.collection('orders');
  Future<void> placeOrder(OrderModel order) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    final newOrder = OrderModel(
      id: order.id,
      userId: user.uid,
      customerName: order.customerName,
      mobile: order.mobile,
      address: order.address,
      totalAmount: order.totalAmount,
      orderDate: order.orderDate,
      status: order.status,
      items: order.items,
    );

    await _orders.add(newOrder.toMap());
  }

  Future<List<OrderModel>> getOrders() async {
    final user = _auth.currentUser;

    if (user == null) {
      return [];
    }

    final snapshot = await _orders
        .where('userId', isEqualTo: user.uid)
        .orderBy('orderDate', descending: true)
        .get();

    return snapshot.docs
        .map(
          (doc) => OrderModel.fromMap(
            doc.data(),
            doc.id,
          ),
        )
        .toList();
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    final doc = await _orders.doc(orderId).get();

    if (!doc.exists) {
      return null;
    }

    final order = OrderModel.fromMap(doc.data()!, doc.id);

    // Security: only allow access to the current user's own order.
    if (order.userId != user.uid) {
      return null;
    }

    return order;
  }

  Future<void> deleteOrder(String orderId) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    final doc = await _orders.doc(orderId).get();

    if (!doc.exists) {
      return;
    }

    final order = OrderModel.fromMap(doc.data()!, doc.id);

    // Security: only allow deleting the current user's own order.
    if (order.userId != user.uid) {
      throw Exception('Unauthorized operation.');
    }

    await _orders.doc(orderId).delete();
  }
}
