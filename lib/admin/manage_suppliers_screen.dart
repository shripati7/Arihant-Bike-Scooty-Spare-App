import 'package:flutter/material.dart';

class ManageSuppliersScreen extends StatelessWidget {
  const ManageSuppliersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Suppliers'),
      ),
      body: const Center(
        child: Text(
          'Supplier Management Coming Soon',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
