import 'package:flutter/material.dart';

class ManageDealersScreen extends StatelessWidget {
  const ManageDealersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Dealers'),
      ),
      body: const Center(
        child: Text(
          'Dealer Management Coming Soon',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
