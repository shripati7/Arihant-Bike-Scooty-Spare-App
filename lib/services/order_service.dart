import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/order_model.dart';
import 'user_service.dart';

class OrderService {
  OrderService._();

  static final OrderService instance = OrderService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _orders =>
      _firestore.collection('orders');

  Future<void> placeOrder(OrderModel order) async {
    final shopId = await UserService.instance.getCurrentUserShopId() ?? '';

    final newOrder = OrderModel(
      id: null,
      customerName: order.customerName,
      mobile: order.mobile,
      address: order.address,
      pinCode: order.pinCode,
      totalAmount: order.totalAmount,
      orderDate: DateTime.now().toIso8601String(),
      status: "Pending",
      items: order.items,
      shopId: shopId,
    );

    await _orders.add(newOrder.toMap());
  }

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

  Future<List<OrderModel>> getMyOrders() async {
    return getOrders();
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
