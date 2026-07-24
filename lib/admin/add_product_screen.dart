import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/image_upload_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final ImageUploadService imageService = ImageUploadService();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController wholesalePriceController =
      TextEditingController();

  final TextEditingController minimumWholesaleQtyController =
      TextEditingController();

  final TextEditingController categoryController = TextEditingController();

  final TextEditingController stockController = TextEditingController();

  XFile? selectedImage;

  String imageUrl = "";

  bool loading = false;
  Future<void> pickImageFromGallery() async {
    final image = await imageService.pickFromGallery();

    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  Future<void> pickImageFromCamera() async {
    final image = await imageService.pickFromCamera();

    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  Future<bool> uploadProductImage() async {
    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a product image"),
        ),
      );
      return false;
    }

    final url = await imageService.uploadImage(
      imageFile: selectedImage!,
      folderName: "products",
    );

    if (url == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Image upload failed"),
          ),
        );
      }
      return false;
    }

    imageUrl = url;
    return true;
  }

  Future<void> saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a product image"),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final uploaded = await uploadProductImage();

      if (!uploaded) {
        setState(() {
          loading = false;
        });
        return;
      }
      await FirebaseFirestore.instance.collection("products").add({
        "name": nameController.text.trim(),

        // Retail Price
        "price": double.parse(priceController.text),

        // Wholesale Price
        "wholesalePrice": double.parse(wholesalePriceController.text),

        // Minimum Wholesale Qty
        "minimumWholesaleQty": int.parse(minimumWholesaleQtyController.text),

        // Firebase Storage Image URL
        "image": imageUrl,

        "category": categoryController.text.trim(),

        "rating": 5.0,

        "stock": int.parse(stockController.text),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product Added Successfully"),
        ),
      );

      nameController.clear();
      priceController.clear();
      wholesalePriceController.clear();
      minimumWholesaleQtyController.clear();
      categoryController.clear();
      stockController.clear();

      setState(() {
        selectedImage = null;
        imageUrl = "";
      });

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    wholesalePriceController.dispose();
    minimumWholesaleQtyController.dispose();
    categoryController.dispose();
    stockController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Product Image",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 220,
                  color: Colors.grey.shade200,
                  child: selectedImage == null
                      ? const Center(
                          child: Icon(
                            Icons.image,
                            size: 90,
                            color: Colors.grey,
                          ),
                        )
                      : Image.file(
                          File(selectedImage!.path),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: loading ? null : pickImageFromCamera,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Camera"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: loading ? null : pickImageFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text("Gallery"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter product name";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Product Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter retail price";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Retail Price",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: wholesalePriceController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter wholesale price";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Wholesale Price",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: minimumWholesaleQtyController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter minimum wholesale quantity";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Minimum Wholesale Qty",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: categoryController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter category";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter stock";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Stock",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: loading ? null : saveProduct,
                  icon: loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.cloud_upload),
                  label: Text(
                    loading ? "Uploading Product..." : "Save Product",
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (selectedImage != null)
                OutlinedButton.icon(
                  onPressed: loading
                      ? null
                      : () {
                          setState(() {
                            selectedImage = null;
                            imageUrl = "";
                          });
                        },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text("Remove Selected Image"),
                ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.blue.shade100,
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Select a clear product image before saving. "
                        "The image will be uploaded automatically to Firebase Storage.",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
