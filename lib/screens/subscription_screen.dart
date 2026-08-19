import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/subscription_config.dart';
import '../services/auth_service.dart';
import '../services/settings_service.dart';
import '../services/user_service.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  Future<void> _contactSupport(String mobile) async {
    final user = await UserService.instance.getCurrentUser();

    final phone = AuthService.instance.currentUser?.phoneNumber ?? '';

    final message = '''
Hello Arihant Team,

I want to activate my subscription.

Shop Code: ${user?.shopCode ?? '-'}
Name: ${user?.name ?? '-'}
Mobile: $phone

Please activate my account.
''';

    final whatsappUri = Uri.parse(
      'https://wa.me/91$mobile?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SubscriptionConfig>(
      future: SettingsService.instance.getSubscriptionConfig(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final config = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Subscription Required"),
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_clock,
                  size: 100,
                  color: Colors.red,
                ),
                const SizedBox(height: 20),
                Text(
                  "Your ${config.trialDays} Day Trial Has Expired",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Monthly Plan ₹${config.monthlyPrice}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Please contact Arihant Support to activate your subscription.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () => _contactSupport(config.supportNumber),
                  icon: const Icon(Icons.chat),
                  label: const Text(
                    "Activate Subscription on WhatsApp",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
