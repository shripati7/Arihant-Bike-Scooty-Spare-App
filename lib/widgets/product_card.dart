import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../screens/product_detail_screen.dart';
import '../utils/pricing_helper.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final sellingPrice = PricingHelper.getSellingPrice(
      product: product,
      isRetailer: false,
      quantity: 1,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: product.image.isEmpty
                    ? const Icon(
                        Icons.motorcycle,
                        size: 70,
                        color: Colors.red,
                      )
                    : product.image.startsWith("http")
                        ? Image.network(
                            product.image,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.motorcycle,
                                size: 70,
                                color: Colors.red,
                              );
                            },
                          )
                        : Image.asset(
                            product.image,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.motorcycle,
                                size: 70,
                                color: Colors.red,
                              );
                            },
                          ),
              ),
              const SizedBox(height: 8),
              Text(
                product.name,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                PricingHelper.format(sellingPrice),
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              if (product.wholesalePrice < product.price)
                Text(
                  "Wholesale ${PricingHelper.format(product.wholesalePrice)} (Min ${product.minimumWholesaleQty})",
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(product.rating.toString()),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text("Add to Cart"),
                  onPressed: () {
                    Provider.of<CartProvider>(
                      context,
                      listen: false,
                    ).addItem(
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
