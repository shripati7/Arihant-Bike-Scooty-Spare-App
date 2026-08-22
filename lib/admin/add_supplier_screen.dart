import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/supplier_model.dart';
import '../services/supplier_service.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final companyController = TextEditingController();
  final ownerController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();

  bool loading = false;

  Future<void> saveSupplier() async {
    if (companyController.text.trim().isEmpty ||
        ownerController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      loading = true;
    });

    final supplierId =
        FirebaseFirestore.instance.collection('suppliers').doc().id;

    final supplier = SupplierModel(
      supplierId: supplierId,
      companyName: companyController.text.trim(),
      companyCode: supplierId.substring(0, 6).toUpperCase(),
      ownerName: ownerController.text.trim(),
      mobile: mobileController.text.trim(),
      email: emailController.text.trim(),
      address: '',
      logo: '',
      trialStart: Timestamp.now(),
      trialEnd: Timestamp.fromDate(
        DateTime.now().add(
          const Duration(days: 60),
        ),
      ),
      subscriptionStatus: 'Trial',
      isActive: true,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );

    await SupplierService.instance.createSupplier(supplier);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Supplier'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: companyController,
              decoration: const InputDecoration(
                labelText: 'Company Name',
              ),
            ),
            TextField(
              controller: ownerController,
              decoration: const InputDecoration(
                labelText: 'Owner Name',
              ),
            ),
            TextField(
              controller: mobileController,
              decoration: const InputDecoration(
                labelText: 'Mobile',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : saveSupplier,
              child: const Text('Save Supplier'),
            ),
          ],
        ),
      ),
    );
  }
}
