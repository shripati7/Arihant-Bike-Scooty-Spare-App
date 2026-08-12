class ShopSettings {
  final String shopName;
  final String mobile;
  final String address;
  final String logo;

  ShopSettings({
    required this.shopName,
    required this.mobile,
    required this.address,
    required this.logo,
  });

  factory ShopSettings.fromMap(Map<String, dynamic> map) {
    return ShopSettings(
      shopName: map['shopName'] ?? '',
      mobile: map['mobile'] ?? '',
      address: map['address'] ?? '',
      logo: map['logo'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shopName': shopName,
      'mobile': mobile,
      'address': address,
      'logo': logo,
    };
  }
}
