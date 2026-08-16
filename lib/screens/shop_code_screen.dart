import 'package:flutter/material.dart';

class ShopCodeScreen extends StatefulWidget {
  const ShopCodeScreen({super.key});

  @override
  State<ShopCodeScreen> createState() => _ShopCodeScreenState();
}

class _ShopCodeScreenState extends State<ShopCodeScreen> {
  final TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Shop Code"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.store,
              size: 90,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Shop Code",
                hintText: "ARI001",
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
