import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../utils/pricing_helper.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Temporary: Retail Customer
    final sellingPrice = PricingHelper.getSellingPrice(
      product: product,
      isRetailer: false,
      quantity: 1,
    );

    return Scaffold(
      appBar: AppBar(title: Text(product.name), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: product.image.isEmpty
                  ? const Icon(Icons.motorcycle, size: 170, color: Colors.red)
                  : product.image.startsWith("http")
                      ? Image.network(
                          product.image,
                          height: 280,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.motorcycle,
                              size: 170,
                              color: Colors.red,
                            );
                          },
                        )
                      : Image.asset(
                          product.image,
                          height: 280,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.motorcycle,
                              size: 170,
                              color: Colors.red,
                            );
                          },
                        ),
            ),
            const SizedBox(height: 28),
            Text(
              product.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange),
                const SizedBox(width: 5),
                Text(
                  product.rating.toString(),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Retail Price",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              PricingHelper.format(sellingPrice),
              style: const TextStyle(
                fontSize: 34,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (product.wholesalePrice < product.price)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.blue.shade50,
                child: ListTile(
                  leading: const Icon(
                    Icons.store,
                    color: Colors.blue,
                    size: 30,
                  ),
                  title: Text(
                    "Wholesale Price : ${PricingHelper.format(product.wholesalePrice)}",
                  ),
                  subtitle: Text(
                    "Minimum Order : ${product.minimumWholesaleQty}",
                  ),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              "Product Description",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "${product.name} is a high quality spare part suitable for bikes and scooties. Genuine quality with reliable performance for daily use.",
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart),
                label: const Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  context.read<CartProvider>().addItem(
                        id: product.id,
                        name: product.name,
                        image: product.image,
                        price: sellingPrice,
                        retailPrice: product.price,
                        wholesalePrice: product.wholesalePrice,
                        minimumWholesaleQty: product.minimumWholesaleQty,
                      );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${product.name} added to cart"),
                      duration: const Duration(seconds: 1),
                    ),
                  );

                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
