import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsService {
  static Future<Map<String, dynamic>?> getSettings() async {
    final doc = await FirebaseFirestore.instance
        .collection('settings')
        .doc('app_config')
        .get();

    return doc.data();
  }
}
