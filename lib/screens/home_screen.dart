import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/banner_slider.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';
import '../widgets/bottom_nav.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  String searchText = "";

  final List<String> categories = [
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

  final List<Product> products = [
    Product(
      name: "Engine Oil 900ml",
      image: "",
      price: 299,
      category: "Engine Oil",
      rating: 4.8,
    ),
    Product(
      name: "Amaron Battery",
      image: "",
      price: 899,
      category: "Battery",
      rating: 4.7,
    ),
    Product(
      name: "Brake Shoe",
      image: "",
      price: 249,
      category: "Brake",
      rating: 4.6,
    ),
    Product(
      name: "Helmet",
      image: "",
      price: 799,
      category: "Helmet",
      rating: 4.5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((product) {
      return product.name.toLowerCase().contains(searchText.toLowerCase()) ||
          product.category.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Arihant Bike & Scooty Spare"),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartScreen(),
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
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryCard(
                    title: categories[index],
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
            GridView.builder(
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
            ),
          ],
        ),
      ),
    );
  }
}
