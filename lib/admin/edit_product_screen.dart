import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  final String id;
  final Map<String, dynamic> product;

  const EditProductScreen({
    super.key,
    required this.id,
    required this.product,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController imageController;
  late TextEditingController categoryController;
  late TextEditingController stockController;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.product["name"] ?? "");

    priceController = TextEditingController(
      text: widget.product["price"].toString(),
    );

    imageController =
        TextEditingController(text: widget.product["image"] ?? "");

    categoryController =
        TextEditingController(text: widget.product["category"] ?? "");

    stockController = TextEditingController(
      text: widget.product["stock"].toString(),
    );
  }

  Future<void> updateProduct() async {
    setState(() => loading = true);

    await FirebaseFirestore.instance
        .collection("products")
        .doc(widget.id)
        .update({
      "name": nameController.text.trim(),
      "price": double.parse(priceController.text),
      "image": imageController.text.trim(),
      "category": categoryController.text.trim(),
      "stock": int.parse(stockController.text),
    });

    setState(() => loading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Product Updated"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Product Name",
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price",
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(
                labelText: "Image URL",
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: "Category",
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Stock",
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : updateProduct,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Update Product"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
