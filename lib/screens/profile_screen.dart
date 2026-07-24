import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String phoneNumber = "8178478220";

  Future<void> _makePhoneCall(BuildContext context) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to open phone dialer"),
        ),
      );
    }
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    final Uri whatsappUri = Uri.parse(
      "https://wa.me/91$phoneNumber?text=Hello%20Arihant%20Bike%20%26%20Scooty%20Spare",
    );

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed."),
        ),
      );
    }
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: "Arihant Bike & Scooty Spare",
      applicationVersion: "1.0.0",
      applicationLegalese: "© 2026 Arihant Bike & Scooty Spare",
      children: const [
        SizedBox(height: 10),
        Text(
          "Your trusted bike & scooty spare parts store.\n\n"
          "Address:\n"
          "E-44, Street No.15,\n"
          "Madhu Vihar, I.P. Extension,\n"
          "Patparganj, Delhi - 110092",
        ),
      ],
    );
  }

  void _showPrivacy(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Privacy Policy"),
        content: const Text(
          "Your information is used only for processing orders. "
          "We do not share your personal information with third parties.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 50,
            child: Icon(
              Icons.person,
              size: 55,
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Arihant Bike & Scooty Spare",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Center(
            child: Text(
              "Welcome to your profile",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 30),
          Card(
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text("My Orders"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("My Orders feature coming soon"),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.call),
              title: const Text("Call Shop"),
              trailing: const Icon(Icons.phone),
              onTap: () => _makePhoneCall(context),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.chat),
              title: const Text("WhatsApp"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _openWhatsApp(context),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About App"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showAbout(context),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text("Privacy Policy"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showPrivacy(context),
            ),
          ),
          const SizedBox(height: 35),
          const Divider(),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              "Version 1.0.0",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
