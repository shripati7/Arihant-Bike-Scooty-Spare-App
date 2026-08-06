import 'package:cloud_firestore/cloud_firestore.dart';

class SupplierModel {
  final String supplierId;
  final String companyName;
  final String companyCode;
  final String ownerName;
  final String mobile;
  final String email;
  final String address;
  final String logo;

  final Timestamp trialStart;
  final Timestamp trialEnd;

  final String subscriptionStatus;
  final bool isActive;

  final Timestamp createdAt;
  final Timestamp updatedAt;

  const SupplierModel({
    required this.supplierId,
    required this.companyName,
    required this.companyCode,
    required this.ownerName,
    required this.mobile,
    required this.email,
    required this.address,
    required this.logo,
    required this.trialStart,
    required this.trialEnd,
    required this.subscriptionStatus,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'supplierId': supplierId,
      'companyName': companyName,
      'companyCode': companyCode,
      'ownerName': ownerName,
      'mobile': mobile,
      'email': email,
      'address': address,
      'logo': logo,
      'trialStart': trialStart,
      'trialEnd': trialEnd,
      'subscriptionStatus': subscriptionStatus,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory SupplierModel.fromMap(Map<String, dynamic> map) {
    return SupplierModel(
      supplierId: map['supplierId'] ?? '',
      companyName: map['companyName'] ?? '',
      companyCode: map['companyCode'] ?? '',
      ownerName: map['ownerName'] ?? '',
      mobile: map['mobile'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      logo: map['logo'] ?? '',
      trialStart: map['trialStart'] ?? Timestamp.now(),
      trialEnd: map['trialEnd'] ?? Timestamp.now(),
      subscriptionStatus: map['subscriptionStatus'] ?? 'Trial',
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] ?? Timestamp.now(),
      updatedAt: map['updatedAt'] ?? Timestamp.now(),
    );
  }
}
