class Product {
  final String id;
  final String name;
  final String image;

  // Shop ID
  final String shopId;

  // Retail Price
  final double price;

  // Wholesale Price
  final double wholesalePrice;

  // Minimum quantity for wholesale
  final int minimumWholesaleQty;

  final String category;
  final double rating;
  final int stock;

  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.image,
    this.shopId = '',
    required this.price,
    required this.wholesalePrice,
    required this.minimumWholesaleQty,
    required this.category,
    required this.rating,
    required this.stock,
    this.quantity = 1,
  });

  factory Product.fromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    return Product(
      id: id,
      name: data["name"] ?? "",
      image: data["image"] ?? "",

      // Shop ID
      shopId: data["shopId"] ?? "",

      // Retail Price
      price: (data["price"] as num?)?.toDouble() ?? 0.0,

      // Wholesale Price
      wholesalePrice: (data["wholesalePrice"] as num?)?.toDouble() ??
          (data["price"] as num?)?.toDouble() ??
          0.0,

      // Minimum quantity for wholesale
      minimumWholesaleQty: data["minimumWholesaleQty"] ?? 1,

      category: data["category"] ?? "",

      // Default rating
      rating: (data["rating"] as num?)?.toDouble() ?? 5.0,

      stock: data["stock"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "image": image,
      "shopId": shopId,
      "price": price,
      "wholesalePrice": wholesalePrice,
      "minimumWholesaleQty": minimumWholesaleQty,
      "category": category,
      "rating": rating,
      "stock": stock,
    };
  }
}
