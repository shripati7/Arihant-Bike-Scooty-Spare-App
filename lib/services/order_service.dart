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

    final newOrder = OrderModel(
      id: null,
      userId: user?.uid ?? '',
      customerName: order.customerName,
      mobile: order.mobile,
      address: order.address,
      totalAmount: order.totalAmount,
      orderDate: DateTime.now().toIso8601String(),
      status: "Pending",
      items: order.items,
    );

    await _orders.add(newOrder.toMap());
  }

  // ==========================
  // ADMIN : All Orders
  // ==========================
  Future<List<OrderModel>> getOrders() async {
    final snapshot = await _orders.orderBy('orderDate', descending: true).get();

    return snapshot.docs
        .map(
          (doc) => OrderModel.fromMap(
            doc.data(),
            doc.id,
          ),
        )
        .toList();
  }

  // ==========================
  // CUSTOMER : My Orders
  // ==========================
  Future<List<OrderModel>> getMyOrders() async {
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
    final doc = await _orders.doc(orderId).get();

    if (!doc.exists) return null;

    return OrderModel.fromMap(
      doc.data()!,
      doc.id,
    );
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    await _orders.doc(orderId).update({
      'status': status,
    });
  }

  Future<void> deleteOrder(String orderId) async {
    await _orders.doc(orderId).delete();
  }
}
