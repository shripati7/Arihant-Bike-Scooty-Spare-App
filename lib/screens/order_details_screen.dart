import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailsScreen extends StatelessWidget {
  final DocumentSnapshot order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final data = order.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Customer Name"),
                subtitle: Text(
                  data['customerName'] ?? '',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: const Text("Mobile Number"),
                subtitle: Text(
                  data['mobile'] ?? '',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text("Delivery Address"),
                subtitle: Text(
                  data['address'] ?? '',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.currency_rupee),
                title: const Text("Total Amount"),
                subtitle: Text(
                  "₹${data['totalAmount']}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.local_shipping),
                title: const Text("Order Status"),
                subtitle: Text(
                  data['status'] ?? 'Pending',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text("Order Date"),
                subtitle: Text(
                  data['orderDate'] ?? 'Not Available',
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Next Version:
                  // Call Customer
                },
                icon: const Icon(Icons.call),
                label: const Text("Call Customer"),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Next Version:
                  // WhatsApp Customer
                },
                icon: const Icon(Icons.chat),
                label: const Text("WhatsApp Customer"),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Back"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
