import 'package:flutter/material.dart';

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
              onPressed: () {},
              child: const Text("Create Shop"),
            ),
          ],
        ),
      ),
    );
  }
}
