import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/firestore_service.dart';
import '../services/user_service.dart';
import '../widgets/product_card.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final FirestoreService firestoreService = FirestoreService();

  late final Stream<List<Product>> productsStream;

  List<String> categories = ["All"];

  String selectedCategory = "All";

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadProducts();

    firestoreService.getCategories().listen((list) {
      if (!mounted) return;

      setState(() {
        categories = ["All", ...list];
        loading = false;
      });
    });
  }

  Future<void> loadProducts() async {
    final shopId = await UserService.instance.getCurrentUserShopId();

    if (shopId == null) return;

    setState(() {
      productsStream = firestoreService.getProducts(shopId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                const SizedBox(height: 12),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: selectedCategory == category,
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Expanded(
                  child: StreamBuilder<List<Product>>(
                    stream: productsStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text("No Products Found"),
                        );
                      }

                      final products = snapshot.data!
                          .where(
                            (product) =>
                                selectedCategory == "All" ||
                                product.category == selectedCategory,
                          )
                          .toList();

                      if (products.isEmpty) {
                        return const Center(
                          child: Text(
                            "No Products Found",
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.58,
                        ),
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: products[index],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
