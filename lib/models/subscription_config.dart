class SubscriptionConfig {
  final int monthlyPrice;
  final int trialDays;
  final bool isSubscriptionEnabled;
  final String supportNumber;

  SubscriptionConfig({
    required this.monthlyPrice,
    required this.trialDays,
    required this.isSubscriptionEnabled,
    required this.supportNumber,
  });

  factory SubscriptionConfig.fromMap(Map<String, dynamic> map) {
    return SubscriptionConfig(
      monthlyPrice: map['monthlyPrice'] ?? 499,
      trialDays: map['trialDays'] ?? 60,
      isSubscriptionEnabled: map['isSubscriptionEnabled'] ?? true,
      supportNumber: map['supportNumber'] ?? '',
    );
  }
}
