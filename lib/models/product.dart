class Product {
  final String name;
  final String image;
  final double price;
  final String category;
  final double rating;

  int quantity;

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.category,
    required this.rating,
    this.quantity = 1,
  });
}
