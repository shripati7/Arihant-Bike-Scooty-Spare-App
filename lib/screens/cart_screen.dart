import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        centerTitle: true,
      ),
      body: cart.cartItems.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 20),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cart.cartItems[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.shopping_bag,
                                  color: Colors.red,
                                ),
                                title: Text(product.name),
                                subtitle: Text(
                                  "₹${product.price.toStringAsFixed(0)}",
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          cart.decreaseQuantity(product);
                                        },
                                        icon: const Icon(Icons.remove_circle),
                                      ),
                                      Text(
                                        product.quantity.toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          cart.increaseQuantity(product);
                                        },
                                        icon: const Icon(Icons.add_circle),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "₹${(product.price * product.quantity).toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹${cart.totalPrice.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CheckoutScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Place Order",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
