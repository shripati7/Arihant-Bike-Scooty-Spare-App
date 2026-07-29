import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/order_model.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final TextEditingController _searchController = TextEditingController();

  String searchText = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Orders"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              12,
              0,
              12,
              12,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value.trim().toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search by Name, Mobile or Order ID",
                prefixIcon: const Icon(
                  Icons.search,
                ),
                suffixIcon: searchText.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(
                          Icons.clear,
                        ),
                        onPressed: () {
                          _searchController.clear();

                          setState(() {
                            searchText = "";
                          });
                        },
                      ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy(
              'orderDate',
              descending: true,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Something went wrong",
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Orders Found",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }

          final orders = snapshot.data!.docs
              .map(
                (doc) => OrderModel.fromMap(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList();

          // ===== Part 2 se continue hoga =====
          final filteredOrders = orders.where((order) {
            if (searchText.isEmpty) {
              return true;
            }

            return order.customerName.toLowerCase().contains(searchText) ||
                order.mobile.toLowerCase().contains(searchText) ||
                (order.id ?? "").toLowerCase().contains(searchText);
          }).toList();

          if (filteredOrders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "No Matching Orders Found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.shopping_cart),
                  ),
                  title: Text(
                    order.customerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text("📞 ${order.mobile}"),
                      Text(
                        "💰 ₹${order.totalAmount.toStringAsFixed(2)}",
                      ),
                      Text("📍 ${order.address}"),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: switch (order.status.toLowerCase()) {
                            "pending" => Colors.orange.shade100,
                            "processing" => Colors.blue.shade100,
                            "shipped" => Colors.purple.shade100,
                            "delivered" => Colors.green.shade100,
                            "cancelled" => Colors.red.shade100,
                            _ => Colors.grey.shade200,
                          },
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          order.status,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  onTap: () async {
                    final refresh = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailsScreen(
                          order: order,
                        ),
                      ),
                    );

                    if (refresh == true && mounted) {
                      setState(() {});
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
