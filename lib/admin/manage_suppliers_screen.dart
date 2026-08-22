import 'package:flutter/material.dart';

class ManageSuppliersScreen extends StatelessWidget {
  const ManageSuppliersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Suppliers'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add Supplier Coming Soon'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Text(
          'No Suppliers Found',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
