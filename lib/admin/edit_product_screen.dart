import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  late TextEditingController categoryController;
  late TextEditingController stockController;

  final picker = ImagePicker();

  File? selectedImage;

  bool loading = false;

  String imageUrl = "";

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.product["name"] ?? "",
    );

    priceController = TextEditingController(
      text: (() {
        final price = (widget.product["price"] ?? 0).toDouble();
        return price % 1 == 0 ? price.toInt().toString() : price.toString();
      })(),
    );

    categoryController = TextEditingController(
      text: widget.product["category"] ?? "",
    );

    stockController = TextEditingController(
      text: widget.product["stock"].toString(),
    );

    imageUrl = widget.product["image"] ?? "";
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      selectedImage = File(image.path);
    });
  }

  Future<String> uploadImage() async {
    if (selectedImage == null) {
      return imageUrl;
    }

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final ref =
        FirebaseStorage.instance.ref().child("products").child(fileName);

    await ref.putFile(selectedImage!);

    return await ref.getDownloadURL();
  }

  Future<void> deleteOldImage() async {
    if (selectedImage == null) return;

    if (imageUrl.isEmpty) return;

    try {
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
    } catch (_) {}
  }

  Future<void> updateProduct() async {
    if (nameController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        categoryController.text.trim().isEmpty ||
        stockController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      // Delete old image if user selected a new one
      await deleteOldImage();

      // Upload new image (or keep old image)
      final newImageUrl = await uploadImage();

      // Update Firestore
      await FirebaseFirestore.instance
          .collection("products")
          .doc(widget.id)
          .update({
        "name": nameController.text.trim(),
        "price": double.parse(priceController.text.trim()),
        "category": categoryController.text.trim(),
        "stock": int.parse(stockController.text.trim()),
        "image": newImageUrl,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Product Updated Successfully"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    categoryController.dispose();
    stockController.dispose();
    super.dispose();
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: GestureDetector(
                onTap: loading ? null : pickImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: selectedImage != null
                      ? Image.file(
                          selectedImage!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          imageUrl,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 150,
                            height: 150,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.image,
                              size: 60,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: loading ? null : pickImage,
              icon: const Icon(Icons.photo_library),
              label: const Text("Change Image"),
            ),
            const SizedBox(height: 20),
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
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Price",
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
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : updateProduct,
                child: loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Update Product",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
