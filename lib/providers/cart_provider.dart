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

      _updatePrice(_items[id]!);
    } else {
      final item = CartItem(
        id: id,
        name: name,
        image: image,
        price: price,
        retailPrice: retailPrice,
        wholesalePrice: wholesalePrice,
        minimumWholesaleQty: minimumWholesaleQty,
      );

      _updatePrice(item);

      _items[id] = item;
    }

    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void increaseQuantity(String id) {
    if (!_items.containsKey(id)) return;

    final item = _items[id]!;

    item.quantity++;

    _updatePrice(item);

    notifyListeners();
  }

  void decreaseQuantity(String id) {
    if (!_items.containsKey(id)) return;

    final item = _items[id]!;

    if (item.quantity > 1) {
      item.quantity--;

      _updatePrice(item);
    } else {
      _items.remove(id);
    }

    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  //==============================
  // Automatic Retail / Wholesale
  //==============================

  void _updatePrice(CartItem item) {
    if (item.quantity >= item.minimumWholesaleQty) {
      item.price = item.wholesalePrice;
    } else {
      item.price = item.retailPrice;
    }
  }

  bool isWholesaleApplied(String id) {
    if (!_items.containsKey(id)) return false;

    final item = _items[id]!;

    return item.quantity >= item.minimumWholesaleQty;
  }

  int remainingForWholesale(String id) {
    if (!_items.containsKey(id)) return 0;

    final item = _items[id]!;

    if (item.quantity >= item.minimumWholesaleQty) {
      return 0;
    }

    return item.minimumWholesaleQty - item.quantity;
  }
}
