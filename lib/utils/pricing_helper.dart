import '../models/product.dart';

class PricingHelper {
  const PricingHelper._();

  /// Returns selling price based on customer type and quantity.
  static double getSellingPrice({
    required Product product,
    required bool isRetailer,
    required int quantity,
  }) {
    if (isRetailer &&
        quantity >= product.minimumWholesaleQty &&
        product.wholesalePrice < product.price) {
      return product.wholesalePrice;
    }

    return product.price;
  }

  /// Formats any price as ₹299.00
  static String format(num? price) {
    final value = (price ?? 0).toDouble();
    return "₹${value.toStringAsFixed(2)}";
  }
}
