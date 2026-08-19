import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/shop_settings.dart';
import '../models/subscription_config.dart';

class SettingsService {
  SettingsService._();

  static final SettingsService instance = SettingsService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<SubscriptionConfig> getSubscriptionConfig() async {
    final doc =
        await _firestore.collection('settings').doc('subscription').get();

    if (!doc.exists || doc.data() == null) {
      return SubscriptionConfig(
        monthlyPrice: 499,
        trialDays: 60,
        isSubscriptionEnabled: true,
        supportNumber: '',
      );
    }

    return SubscriptionConfig.fromMap(doc.data()!);
  }

  Future<Map<String, dynamic>?> getSettings() async {
    final doc = await _firestore.collection('settings').doc('app_config').get();

    return doc.data();
  }

  Future<ShopSettings?> getShopSettings(String shopId) async {
    final doc = await _firestore.collection('shops').doc(shopId).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return ShopSettings.fromMap(doc.data()!);
  }

  Future<void> saveShopSettings({
    required String shopId,
    required ShopSettings settings,
  }) async {
    await _firestore.collection('shops').doc(shopId).set(settings.toMap());
  }
}
