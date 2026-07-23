import '../models/product.dart';

class PricingHelper {
  static double getSellingPrice({
    required Product product,
    required bool isRetailer,
    required int quantity,
  }) {
    if (isRetailer && quantity >= product.minimumWholesaleQty) {
      return product.wholesalePrice;
    }

    return product.price;
  }

  static bool isWholesaleEligible({
    required Product product,
    required int quantity,
  }) {
    return quantity >= product.minimumWholesaleQty;
  }

  static String getPriceLabel({
    required Product product,
    required bool isRetailer,
    required int quantity,
  }) {
    if (isRetailer && quantity >= product.minimumWholesaleQty) {
      return "Wholesale Price";
    }

    return "Retail Price";
  }
}
