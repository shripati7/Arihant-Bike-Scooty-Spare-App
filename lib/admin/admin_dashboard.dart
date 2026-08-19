import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_product_screen.dart';
import 'manage_categories_screen.dart';
import 'manage_products_screen.dart';
import 'manage_dealers_screen.dart';
import '../screens/orders_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});
  Future<Map<String, int>> getStats() async {
    final users = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'dealer')
        .get();

    final products =
        await FirebaseFirestore.instance.collection('products').get();

    final orders = await FirebaseFirestore.instance.collection('orders').get();

    final activeDealers = users.docs
        .where(
          (e) => e.data()['isActive'] == true,
        )
        .length;

    return {
      'dealers': users.docs.length,
      'active': activeDealers,
      'expired': users.docs.length - activeDealers,
      'products': products.docs.length,
      'orders': orders.docs.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.admin_panel_settings,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 15),
            const Text(
              "Admin Control Panel",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            FutureBuilder<Map<String, int>>(
              future: getStats(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final stats = snapshot.data!;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text("Dealers : ${stats['dealers']}"),
                        Text("Active : ${stats['active']}"),
                        Text("Expired : ${stats['expired']}"),
                        Text("Products : ${stats['products']}"),
                        Text("Orders : ${stats['orders']}"),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_box),
                label: const Text("Add Product"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddProductScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.inventory_2),
                label: const Text("Manage Products"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ManageProductsScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.category),
                label: const Text("Manage Categories"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ManageCategoriesScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text("View Orders"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OrdersScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.people),
                label: const Text("Manage Dealers"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ManageDealersScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.photo_library),
                label: const Text("Manage Banners"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Banner Management Coming Soon",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
