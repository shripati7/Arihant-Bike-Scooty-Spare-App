class CartItem {
  final String id;
  final String name;
  final String image;

  // Current selling price
  double price;

  // Retail price
  final double retailPrice;

  // Wholesale price
  final double wholesalePrice;

  // Minimum quantity for wholesale
  final int minimumWholesaleQty;

  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.retailPrice,
    required this.wholesalePrice,
    required this.minimumWholesaleQty,
    this.quantity = 1,
  });

  double get total => price * quantity;
}
