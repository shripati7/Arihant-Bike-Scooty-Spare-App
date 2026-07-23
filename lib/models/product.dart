class Product {
  final String id;
  final String name;
  final String image;

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

      // Retail Price
      price: (data["price"] ?? 0).toDouble(),

      // Agar wholesalePrice Firestore me nahi hai,
      // to retail price use hogi.
      wholesalePrice: (data["wholesalePrice"] ?? data["price"] ?? 0).toDouble(),

      // Agar field nahi hai to default 1
      minimumWholesaleQty: data["minimumWholesaleQty"] ?? 1,

      category: data["category"] ?? "",
      rating: (data["rating"] ?? 5).toDouble(),
      stock: data["stock"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "image": image,
      "price": price,
      "wholesalePrice": wholesalePrice,
      "minimumWholesaleQty": minimumWholesaleQty,
      "category": category,
      "rating": rating,
      "stock": stock,
    };
  }
}
