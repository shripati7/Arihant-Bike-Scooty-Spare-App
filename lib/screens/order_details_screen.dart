import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatefulWidget {
  final DocumentSnapshot order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Map<String, dynamic> data;
  late String status;

  @override
  void initState() {
    super.initState();
    data = widget.order.data() as Map<String, dynamic>;
    status = data['status'] ?? "Pending";
  }

  Future<void> updateStatus(String value) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.order.id)
        .update({"status": value});

    setState(() {
      status = value;
    });
  }

  Future<void> callCustomer() async {
    final uri = Uri(scheme: "tel", path: data['mobile']);
    await launchUrl(uri);
  }

  Future<void> whatsappCustomer() async {
    final uri = Uri.parse(
      "https://wa.me/91${data['mobile']}",
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List items = (data['items'] ?? []) as List;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Customer Name"),
              subtitle: Text(data['customerName'] ?? ""),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.phone),
              title: const Text("Mobile"),
              subtitle: Text(data['mobile'] ?? ""),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("Address"),
              subtitle: Text(data['address'] ?? ""),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Ordered Products",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...items.map((item) {
            return Card(
              child: ListTile(
                leading:
                    item['image'] != null && item['image'].toString().isNotEmpty
                        ? Image.network(
                            item['image'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.inventory_2),
                title: Text(item['name'] ?? ""),
                subtitle: Text(
                  "₹${item['price']} × ${item['quantity']}",
                ),
                trailing: Text(
                  "₹${item['total']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            initialValue: status,
            decoration: const InputDecoration(
              labelText: "Order Status",
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: "Pending",
                child: Text("Pending"),
              ),
              DropdownMenuItem(
                value: "Confirmed",
                child: Text("Confirmed"),
              ),
              DropdownMenuItem(
                value: "Shipped",
                child: Text("Shipped"),
              ),
              DropdownMenuItem(
                value: "Delivered",
                child: Text("Delivered"),
              ),
              DropdownMenuItem(
                value: "Cancelled",
                child: Text("Cancelled"),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                updateStatus(value);
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: callCustomer,
            icon: const Icon(Icons.call),
            label: const Text("Call Customer"),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: whatsappCustomer,
            icon: const Icon(Icons.chat),
            label: const Text("WhatsApp Customer"),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.currency_rupee),
              title: const Text("Total Amount"),
              trailing: Text(
                "₹${data['totalAmount']}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
