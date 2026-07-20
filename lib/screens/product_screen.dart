import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Arihant Bike & Scooty Spare"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Home Screen Ready",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}