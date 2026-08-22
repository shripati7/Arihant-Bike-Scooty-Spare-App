import 'package:flutter/material.dart';

import '../models/supplier_model.dart';
import '../services/supplier_service.dart';
import 'add_supplier_screen.dart';

class ManageSuppliersScreen extends StatelessWidget {
  const ManageSuppliersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Suppliers'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddSupplierScreen(),
            ),
          );

          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ManageSuppliersScreen(),
              ),
            );
          }
        },
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
