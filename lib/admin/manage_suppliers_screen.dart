import 'package:flutter/material.dart';

import '../models/supplier_model.dart';
import '../services/supplier_service.dart';

class ManageSuppliersScreen extends StatelessWidget {
  const ManageSuppliersScreen({super.key});

  void _showAddSupplierDialog(BuildContext context) {
    final companyController = TextEditingController();
    final codeController = TextEditingController();
    final ownerController = TextEditingController();
    final mobileController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Supplier'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: companyController,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                ),
              ),
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'Company Code',
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
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Supplier Save Phase Coming Next'),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Suppliers'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSupplierDialog(context),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<SupplierModel>>(
        future: SupplierService.instance.getAllSuppliers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final suppliers = snapshot.data!;

          if (suppliers.isEmpty) {
            return const Center(
              child: Text(
                'No Suppliers Found',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: suppliers.length,
            itemBuilder: (context, index) {
              final supplier = suppliers[index];

              return ListTile(
                title: Text(supplier.companyName),
                subtitle: Text(supplier.ownerName),
                trailing: Text(
                  supplier.subscriptionStatus,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
