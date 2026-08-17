import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../services/user_service.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final TextEditingController _searchController = TextEditingController();

  String searchText = "";
  String? shopId;

  @override
  void initState() {
    super.initState();
    loadShopId();
  }

  Future<void> loadShopId() async {
    shopId = await UserService.instance.getCurrentUserShopId();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (shopId == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchText.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
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
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('shopId', isEqualTo: shopId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(snapshot.error.toString()),
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
                style: TextStyle(fontSize: 18),
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

          final filteredOrders = orders.where((order) {
            if (searchText.isEmpty) return true;

            return order.customerName.toLowerCase().contains(searchText) ||
                order.mobile.toLowerCase().contains(searchText) ||
                (order.id ?? "").toLowerCase().contains(searchText);
          }).toList();

          if (filteredOrders.isEmpty) {
            return const Center(
              child: Text("No Matching Orders Found"),
            );
          }

          return ListView.builder(
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(order.customerName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.mobile),
                      Text("₹${order.totalAmount}"),
                      Text(order.status),
                    ],
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailsScreen(
                          order: order,
                        ),
                      ),
                    );
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
