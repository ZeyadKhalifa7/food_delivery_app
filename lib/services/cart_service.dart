import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class CartService extends ChangeNotifier {
  List<MenuItem> _items = [];

  List<MenuItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.price);

  void addItem(MenuItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(MenuItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // For quantity management, we'll keep it simple: each tap adds one.
  // For removal, we remove one instance (latest).
  void removeOne(MenuItem item) {
    final index = _items.lastIndexWhere((i) => i.id == item.id);
    if (index != -1) _items.removeAt(index);
    notifyListeners();
  }
}