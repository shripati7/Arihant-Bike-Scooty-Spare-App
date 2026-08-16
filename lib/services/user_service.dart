import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class UserService {
  UserService._();

  static final UserService instance = UserService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Save current user to Firestore (only if not already present)
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
      trialEndDate: null,
    );

    await userDoc.set(newUser.toMap());
  }

  /// Get current logged-in user
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

  /// Update user profile
  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toMap());
  }

  /// Get current user's role
  Future<String?> getUserRole() async {
    final user = _auth.currentUser;

    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) return null;

    final data = doc.data();

    return data?['role'] as String?;
  }
}
