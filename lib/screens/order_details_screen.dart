import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/order_model.dart';
import '../services/invoice_service.dart';
import '../services/order_service.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final OrderService _orderService = OrderService.instance;

  final InvoiceService _invoiceService = InvoiceService();

  late String selectedStatus;

  final List<String> statusList = [
    "Pending",
    "Processing",
    "Shipped",
    "Delivered",
    "Cancelled",
  ];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.order.status;
  }

  String formatOrderDate(String date) {
    try {
      return DateFormat(
        "dd MMM yyyy • hh:mm a",
      ).format(DateTime.parse(date));
    } catch (_) {
      return date;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;

      case "processing":
        return Colors.blue;

      case "shipped":
        return Colors.purple;

      case "delivered":
        return Colors.green;

      case "cancelled":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  Future<void> printInvoice() async {
    await _invoiceService.generateAndShareInvoice(
      widget.order,
    );
  }

  Future<void> callCustomer() async {
    final uri = Uri(
      scheme: "tel",
      path: widget.order.mobile,
    );

    await launchUrl(uri);
  }

  Future<void> whatsappCustomer() async {
    final uri = Uri.parse(
      "https://wa.me/91${widget.order.mobile}",
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> updateStatus(
    String value,
  ) async {
    if (widget.order.id == null) return;

    await _orderService.updateOrderStatus(
      orderId: widget.order.id!,
      status: value,
    );

    if (!mounted) return;

    setState(() {
      selectedStatus = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Order status updated to $value",
        ),
      ),
    );
  }

  Future<void> deleteOrder() async {
    if (widget.order.id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Delete Order",
          ),
          content: const Text(
            "Are you sure you want to delete this order?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                "Cancel",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                "Delete",
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await _orderService.deleteOrder(
      widget.order.id!,
    );

    if (!mounted) return;

    Navigator.pop(
      context,
      true,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Order Deleted Successfully",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Details",
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: deleteOrder,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== Action Buttons =====

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: printInvoice,
                        icon: const Icon(Icons.print),
                        label: const Text("Invoice"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: callCustomer,
                        icon: const Icon(Icons.call),
                        label: const Text("Call"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: whatsappCustomer,
                        icon: const Icon(Icons.chat),
                        label: const Text("WhatsApp"),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Customer Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(
                        widget.order.customerName,
                      ),
                      subtitle: const Text(
                        "Customer Name",
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.phone),
                      title: Text(
                        widget.order.mobile,
                      ),
                      subtitle: const Text(
                        "Mobile Number",
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.location_on,
                      ),
                      title: Text(
                        widget.order.address,
                      ),
                      subtitle: const Text(
                        "Address",
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Order Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.receipt_long,
                      ),
                      title: Text(
                        widget.order.id ?? "-",
                      ),
                      subtitle: const Text(
                        "Order ID",
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.calendar_today,
                      ),
                      title: Text(
                        formatOrderDate(
                          widget.order.orderDate,
                        ),
                      ),
                      subtitle: const Text(
                        "Order Date",
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.local_shipping,
                      ),
                      title: DropdownButton<String>(
                        value: selectedStatus,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: statusList
                            .map(
                              (status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            updateStatus(value);
                          }
                        },
                      ),
                      subtitle: const Text(
                        "Status",
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor(
                          selectedStatus,
                        ).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: getStatusColor(
                            selectedStatus,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: getStatusColor(
                              selectedStatus,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            selectedStatus,
                            style: TextStyle(
                              color: getStatusColor(
                                selectedStatus,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ordered Products",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...widget.order.items.map((item) {
                      final quantity = item["quantity"] ?? 0;

                      final price = (item["price"] is num)
                          ? (item["price"] as num).toDouble()
                          : double.tryParse(item["price"].toString()) ?? 0.0;

                      final total = (item["total"] is num)
                          ? (item["total"] as num).toDouble()
                          : double.tryParse(item["total"].toString()) ?? 0.0;

                      final wholesale = item["isWholesale"] ?? false;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["name"] ?? "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text("Quantity : $quantity"),
                              Text("Price : ₹${price.toStringAsFixed(2)}"),
                              Text(
                                "Total : ₹${total.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (wholesale)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Chip(
                                    label: Text("Wholesale"),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    Card(
                      color: Colors.green.shade50,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Grand Total",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "₹${widget.order.totalAmount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
