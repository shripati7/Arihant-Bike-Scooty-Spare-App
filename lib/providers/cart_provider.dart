import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  List<CartItem> get cartItems => _items.values.toList();

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0;

    for (var item in _items.values) {
      total += item.total;
    }

    return total;
  }

  void addItem({
    required String id,
    required String name,
    required String image,
    required double price,
    required double retailPrice,
    required double wholesalePrice,
    required int minimumWholesaleQty,
  }) {
    if (_items.containsKey(id)) {
      _items[id]!.quantity++;
      _items[id]!.price = price;
    } else {
      _items[id] = CartItem(
        id: id,
        name: name,
        image: image,
        price: price,
        retailPrice: retailPrice,
        wholesalePrice: wholesalePrice,
        minimumWholesaleQty: minimumWholesaleQty,
      );
    }

    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void increaseQuantity(String id) {
    if (_items.containsKey(id)) {
      _items[id]!.quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String id) {
    if (!_items.containsKey(id)) return;

    if (_items[id]!.quantity > 1) {
      _items[id]!.quantity--;
    } else {
      _items.remove(id);
    }

    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
