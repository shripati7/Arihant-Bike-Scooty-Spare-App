import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/shop_service.dart';
import '../services/user_service.dart';

class DealerRegistrationScreen extends StatefulWidget {
  const DealerRegistrationScreen({super.key});

  @override
  State<DealerRegistrationScreen> createState() =>
      _DealerRegistrationScreenState();
}

class _DealerRegistrationScreenState extends State<DealerRegistrationScreen> {
  final shopNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final mobileController = TextEditingController();

  Future<void> createShop() async {
    if (shopNameController.text.trim().isEmpty ||
        ownerNameController.text.trim().isEmpty ||
        mobileController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All fields are required"),
        ),
      );
      return;
    }

    try {
      final shopCode = await ShopService.instance.generateShopCode();

      final shopId = FirebaseFirestore.instance.collection('shops').doc().id;

      await ShopService.instance.createShop(
        shopId: shopId,
        shopCode: shopCode,
        shopName: shopNameController.text.trim(),
        ownerName: ownerNameController.text.trim(),
        mobile: mobileController.text.trim(),
      );

      await UserService.instance.assignDealerRole(
        shopId: shopId,
        shopCode: shopCode,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Shop Created Successfully\nShop Code: $shopCode",
          ),
        ),
      );

      shopNameController.clear();
      ownerNameController.clear();
      mobileController.clear();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  @override
  void dispose() {
    shopNameController.dispose();
    ownerNameController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dealer Registration"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Icon(
              Icons.store,
              size: 90,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: shopNameController,
              decoration: const InputDecoration(
                labelText: "Shop Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: ownerNameController,
              decoration: const InputDecoration(
                labelText: "Owner Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Mobile Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: createShop,
              child: const Text("Create Shop"),
            ),
          ],
        ),
      ),
    );
  }
}
