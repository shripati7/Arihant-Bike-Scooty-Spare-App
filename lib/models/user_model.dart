import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String email;
  final String address;
  final Timestamp createdAt;

  // Multi Dealer Fields
  final String role;
  final String shopId;
  final String shopCode;
  final String supplierId;
  final bool isActive;
  final Timestamp? trialEndDate;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.createdAt,
    this.role = '',
    this.shopId = '',
    this.shopCode = '',
    this.supplierId = '',
    this.isActive = true,
    this.trialEndDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'createdAt': createdAt,
      'role': role,
      'shopId': shopId,
      'shopCode': shopCode,
      'supplierId': supplierId,
      'isActive': isActive,
      'trialEndDate': trialEndDate,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      role: map['role'] ?? '',
      shopId: map['shopId'] ?? '',
      shopCode: map['shopCode'] ?? '',
      supplierId: map['supplierId'] ?? '',
      isActive: map['isActive'] ?? true,
      trialEndDate: map['trialEndDate'],
    );
  }
}
