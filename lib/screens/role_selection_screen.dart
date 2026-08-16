import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Account Type'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.business,
              size: 90,
              color: Colors.red,
            ),
            const SizedBox(height: 30),
            const Text(
              'Choose Your Account Type',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.store),
              label: const Text('Dealer'),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person),
              label: const Text('Customer'),
            ),
          ],
        ),
      ),
    );
  }
}
