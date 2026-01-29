import 'package:flutter/material.dart';
import '../models/models.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  String? _currentStallId;

  List<CartItem> get items => _items;
  String? get currentStallId => _currentStallId;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Multi-stall prevention logic
  bool canOrderFromStall(String newStallId) {
    if (_items.isEmpty) return true;
    return _currentStallId == newStallId;
  }

  void addToCart(CartItem item, String stallId) {
    if (_items.isEmpty) {
      _currentStallId = stallId;
    }

    if (_currentStallId == stallId) {
      _items.add(item);
      notifyListeners();
    }
  }

  void clearCart() {
    _items = [];
    _currentStallId = null;
    notifyListeners();
  }
}
