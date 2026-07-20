import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _cartItems.fold(
        0,
        (sum, item) => sum + (item.price * item.quantity),
      );

  void addToCart(Product product) {
    final index = _cartItems.indexWhere(
      (item) => item.name == product.name,
    );

    if (index != -1) {
      _cartItems[index].quantity++;
    } else {
      product.quantity = 1;
      _cartItems.add(product);
    }

    notifyListeners();
  }

  void increaseQuantity(Product product) {
    product.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(Product product) {
    if (product.quantity > 1) {
      product.quantity--;
    } else {
      _cartItems.remove(product);
    }

    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
