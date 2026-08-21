import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

class UserService {
  UserService._();

  static final UserService instance = UserService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUser() async {
    final user = _auth.currentUser;

    if (user == null) return;

    final userDoc = _firestore.collection('users').doc(user.uid);

    final snapshot = await userDoc.get();

    if (snapshot.exists) {
      return;
    }

    final newUser = UserModel(
      uid: user.uid,
      name: '',
      phone: user.phoneNumber ?? '',
      email: user.email ?? '',
      address: '',
      createdAt: Timestamp.now(),
      role: '',
      shopId: '',
      shopCode: '',
      isActive: true,
      trialEndDate: Timestamp.fromDate(
        DateTime.now().add(
          const Duration(days: 60),
        ),
      ),
    );

    await userDoc.set(newUser.toMap());
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return UserModel.fromMap(doc.data()!);
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toMap());
  }

  Future<String?> getUserRole() async {
    final user = _auth.currentUser;

    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) return null;

    final data = doc.data();

    return data?['role'] as String?;
  }

  Future<String?> getCurrentUserShopId() async {
    final user = await getCurrentUser();

    debugPrint("========== USER DEBUG ==========");
    debugPrint("UID = ${user?.uid}");
    debugPrint("ROLE = ${user?.role}");
    debugPrint("SHOP ID = ${user?.shopId}");
    debugPrint("SHOP CODE = ${user?.shopCode}");

    if (user == null) {
      return null;
    }

    return user.shopId;
  }

  Future<void> assignDealerRole({
    required String shopId,
    required String shopCode,
  }) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'role': 'dealer',
      'shopId': shopId,
      'shopCode': shopCode,
      'isActive': true,
      'trialEndDate': Timestamp.fromDate(
        DateTime.now().add(
          const Duration(days: 60),
        ),
      ),
    });
  }

  // ==========================
  // Dealer Management
  // ==========================

  Future<List<UserModel>> getAllDealers() async {
    final snapshot = await _firestore.collection('users').get();

    return snapshot.docs
        .map(
          (doc) => UserModel.fromMap(doc.data()),
        )
        .toList();
  }

  Future<void> updateSubscription({
    required String uid,
    required DateTime expiryDate,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'trialEndDate': Timestamp.fromDate(expiryDate),
      'isActive': true,
    });
  }

  Future<void> updateUserStatus({
    required String uid,
    required bool isActive,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'isActive': isActive,
    });
  }
}
