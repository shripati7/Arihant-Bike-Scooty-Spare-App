import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();

  // Retail Price
  final priceController = TextEditingController();

  // Wholesale Price
  final wholesalePriceController = TextEditingController();

  // Minimum Qty
  final minimumWholesaleQtyController = TextEditingController();

  final imageController = TextEditingController();
  final categoryController = TextEditingController();
  final stockController = TextEditingController();

  bool loading = false;

  Future<void> saveProduct() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        wholesalePriceController.text.isEmpty ||
        minimumWholesaleQtyController.text.isEmpty ||
        imageController.text.isEmpty ||
        categoryController.text.isEmpty ||
        stockController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    setState(() => loading = true);

    await FirebaseFirestore.instance.collection("products").add({
      "name": nameController.text.trim(),

      // Retail Price
      "price": double.parse(priceController.text),

      // Wholesale Price
      "wholesalePrice": double.parse(wholesalePriceController.text),

      // Minimum Qty
      "minimumWholesaleQty": int.parse(minimumWholesaleQtyController.text),

      "image": imageController.text.trim(),
      "category": categoryController.text.trim(),
      "rating": 5.0,
      "stock": int.parse(stockController.text),
    });

    setState(() => loading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product Added Successfully"),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    wholesalePriceController.dispose();
    minimumWholesaleQtyController.dispose();
    imageController.dispose();
    categoryController.dispose();
    stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Product Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Retail Price",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: wholesalePriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Wholesale Price",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: minimumWholesaleQtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Minimum Wholesale Qty",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(
                labelText: "Image URL",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Stock",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : saveProduct,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Save Product"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
