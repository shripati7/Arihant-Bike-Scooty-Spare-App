import 'package:cloud_firestore/cloud_firestore.dart';

class ShopService {
  ShopService._();

  static final ShopService instance = ShopService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _shops =>
      _firestore.collection('shops');

  Future<bool> shopCodeExists(String shopCode) async {
    final snapshot =
        await _shops.where('shopCode', isEqualTo: shopCode).limit(1).get();

    return snapshot.docs.isNotEmpty;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getShopByCode(
      String shopCode) async {
    final snapshot =
        await _shops.where('shopCode', isEqualTo: shopCode).limit(1).get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return snapshot.docs.first;
  }

  Future<void> createShop({
    required String shopId,
    required String shopCode,
    required String shopName,
    required String ownerName,
    required String mobile,
  }) async {
    await _shops.doc(shopId).set({
      'shopId': shopId,
      'shopCode': shopCode,
      'shopName': shopName,
      'ownerName': ownerName,
      'mobile': mobile,
      'isActive': true,
      'createdAt': Timestamp.now(),
      'trialEndDate': Timestamp.fromDate(
        DateTime.now().add(
          const Duration(days: 60),
        ),
      ),
    });
  }
}
