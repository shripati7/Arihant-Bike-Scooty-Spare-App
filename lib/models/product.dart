class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final String category;
  final double rating;
  final int stock;

  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.category,
    required this.rating,
    required this.stock,
    this.quantity = 1,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data["name"] ?? "",
      image: data["image"] ?? "",
      price: (data["price"] ?? 0).toDouble(),
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
      "category": category,
      "rating": rating,
      "stock": stock,
    };
  }
}
