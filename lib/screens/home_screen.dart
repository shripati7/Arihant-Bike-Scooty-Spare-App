import 'package:flutter/material.dart';

import '../admin/admin_login_screen.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';
import '../widgets/banner_slider.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/category_card.dart';
import '../widgets/category_filter.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService firestoreService = FirestoreService();

  int currentIndex = 0;
  String searchText = "";
  String selectedCategory = "All";

  final List<String> categories = [
    "All",
    "Engine Oil",
    "Battery",
    "Brake",
    "Helmet",
    "Tyre",
    "Bulb",
  ];

  final List<String> topCategories = [
    "Engine Oil",
    "Battery",
    "Brake",
    "Helmet",
    "Tyre",
    "Bulb",
  ];

  final List<IconData> categoryIcons = [
    Icons.oil_barrel,
    Icons.battery_charging_full,
    Icons.car_repair,
    Icons.health_and_safety,
    Icons.tire_repair,
    Icons.lightbulb,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Arihant Bike & Scooty Spare"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminLoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CartScreen(),
              ),
            );
            return;
          }

          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search spare parts...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const BannerSlider(),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Filter By Category",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CategoryFilter(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Categories",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topCategories.length,
                itemBuilder: (context, index) {
                  return CategoryCard(
                    title: topCategories[index],
                    icon: categoryIcons[index],
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Featured Products",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            StreamBuilder<List<Product>>(
              stream: firestoreService.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Text("Something went wrong"),
                    ),
                  );
                }

                final allProducts = snapshot.data ?? [];

                final filteredProducts = allProducts.where((product) {
                  final searchMatch = product.name
                          .toLowerCase()
                          .contains(searchText.toLowerCase()) ||
                      product.category
                          .toLowerCase()
                          .contains(searchText.toLowerCase());

                  final categoryMatch = selectedCategory == "All"
                      ? true
                      : product.category == selectedCategory;

                  return searchMatch && categoryMatch;
                }).toList();

                if (filteredProducts.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child: Text(
                        "No Products Found",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  itemCount: filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: filteredProducts[index],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
