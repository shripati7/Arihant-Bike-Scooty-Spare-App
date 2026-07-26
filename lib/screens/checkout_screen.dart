import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../providers/cart_provider.dart';
import '../services/order_service.dart';
import '../utils/pricing_helper.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalAmount;

  const CheckoutScreen({
    super.key,
    required this.totalAmount,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController mobileController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final OrderService orderService = OrderService.instance;

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> placeOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cartProvider = Provider.of<CartProvider>(
      context,
      listen: false,
    );

    final items = cartProvider.cartItems.map((item) {
      return {
        "id": item.id,
        "name": item.name,
        "image": item.image,
        "price": item.price,
        "retailPrice": item.retailPrice,
        "wholesalePrice": item.wholesalePrice,
        "minimumWholesaleQty": item.minimumWholesaleQty,
        "quantity": item.quantity,
        "total": item.total,
        "isWholesale": item.quantity >= item.minimumWholesaleQty,
      };
    }).toList();
    final order = OrderModel(
      id: null,

      // OrderService.placeOrder() इसे
      // current Firebase user's UID से save करेगा.
      userId: '',

      customerName: nameController.text.trim(),
      mobile: mobileController.text.trim(),
      address: addressController.text.trim(),

      totalAmount: cartProvider.totalAmount,

      orderDate: DateTime.now().toIso8601String(),

      status: 'Pending',

      items: items,
    );

    await orderService.placeOrder(order);

    if (!mounted) return;

    cartProvider.clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Order Placed Successfully",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Customer Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter customer name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Mobile Number",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.trim().length != 10) {
                    return "Enter valid mobile number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Delivery Address",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        "Order Summary",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      ...cart.cartItems.map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                "${item.quantity} × ₹${PricingHelper.format(item.price)}",
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "₹${PricingHelper.format(item.total)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(),
                      Row(
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
                            "₹${PricingHelper.format(cart.totalAmount)}",
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: placeOrder,
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text(
                    "Place Order",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
