import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/image_upload_service.dart';
import '../services/user_service.dart';

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

  final TextEditingController stockController = TextEditingController();

  XFile? selectedImage;

  String imageUrl = "";

  bool loading = false;

  List<String> categories = [];

  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("categories")
          .orderBy("name")
          .get();

      categories = snapshot.docs
          .map(
            (doc) => (doc.data()["name"] ?? "").toString(),
          )
          .where(
            (category) => category.trim().isNotEmpty,
          )
          .toList();

      if (categories.isNotEmpty) {
        selectedCategory = categories.first;
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint(
        "Category Load Error: $e",
      );
    }
  }

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
      if (!mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select a product image",
          ),
        ),
      );

      return false;
    }

    final url = await imageService.uploadImage(
      imageFile: selectedImage!,
      folderName: "products",
    );

    if (url == null) {
      if (!mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Image upload failed",
          ),
        ),
      );

      return false;
    }

    imageUrl = url;

    return true;
  }

  Future<void> saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a category"),
        ),
      );
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

      final shopId = await UserService.instance.getCurrentUserShopId();

      if (!uploaded) {
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
        return;
      }

      await FirebaseFirestore.instance.collection("products").add({
        "name": nameController.text.trim(),

        // Retail Price
        "price": double.parse(
          priceController.text.trim(),
        ),

        // Wholesale Price
        "wholesalePrice": double.parse(
          wholesalePriceController.text.trim(),
        ),

        // Minimum Wholesale Qty
        "minimumWholesaleQty": int.parse(
          minimumWholesaleQtyController.text.trim(),
        ),

        // Product Category
        "category": selectedCategory,

        // Firebase Storage Image URL
        "image": imageUrl,

        // Default Rating
        "rating": 5.0,

        // Stock
        "stock": int.parse(
          stockController.text.trim(),
        ),

        // Created Time
        "createdAt": FieldValue.serverTimestamp(),
        "shopId": shopId ?? "",
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Product Added Successfully",
          ),
        ),
      );

      nameController.clear();
      priceController.clear();
      wholesalePriceController.clear();
      minimumWholesaleQtyController.clear();
      stockController.clear();

      setState(() {
        selectedImage = null;
        imageUrl = "";

        if (categories.isNotEmpty) {
          selectedCategory = categories.first;
        }
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
                decoration: const InputDecoration(
                  labelText: "Product Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter product name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Retail Price",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter retail price";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: wholesalePriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Wholesale Price",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter wholesale price";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: minimumWholesaleQtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Minimum Wholesale Qty",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter minimum wholesale quantity";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                items: categories
                    .map(
                      (category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: loading
                    ? null
                    : (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select a category";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Stock",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter stock";
                  }
                  return null;
                },
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
