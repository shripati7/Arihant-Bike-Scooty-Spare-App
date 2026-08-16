import 'package:cloud_firestore/cloud_firestore.dart';

class ShopModel {
  final String shopId;
  final String shopCode;
  final String shopName;
  final String ownerName;
  final String mobile;
  final bool isActive;
  final Timestamp createdAt;
  final Timestamp trialEndDate;

  ShopModel({
    required this.shopId,
    required this.shopCode,
    required this.shopName,
    required this.ownerName,
    required this.mobile,
    required this.isActive,
    required this.createdAt,
    required this.trialEndDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'shopId': shopId,
      'shopCode': shopCode,
      'shopName': shopName,
      'ownerName': ownerName,
      'mobile': mobile,
      'isActive': isActive,
      'createdAt': createdAt,
      'trialEndDate': trialEndDate,
    };
  }

  factory ShopModel.fromMap(Map<String, dynamic> map) {
    return ShopModel(
      shopId: map['shopId'] ?? '',
      shopCode: map['shopCode'] ?? '',
      shopName: map['shopName'] ?? '',
      ownerName: map['ownerName'] ?? '',
      mobile: map['mobile'] ?? '',
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] ?? Timestamp.now(),
      trialEndDate: map['trialEndDate'] ?? Timestamp.now(),
    );
  }
}
