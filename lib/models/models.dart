import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class FoodItem {
  final String id;
  final String name;
  final double price;
  final String photoUrl;
  final int stock;
  final String stallname;

  FoodItem({
    required this.id,
    required this.name,
    required this.price,
    required this.photoUrl,
    required this.stock,
    required this.stallname,
  });

  // Inside models.dart
  factory FoodItem.fromSnapshot(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  return FoodItem(
    name: data['item'] ?? data['name'] ?? 'Unknown',     // Your drawing says 'item'
    price: (data['price'] as num).toDouble(),  // Your drawing says 'price'
    photoUrl: data['image'] ?? '', // Your drawing says 'image'
    id: doc.id,
    stock: (data['stock'] ?? 0).toInt(),
    stallname:(data['stall'] ?? ''),
  );
}
}

class CartItem {
  final FoodItem food;
  final int quantity;
  final List<dynamic> selectedaddons;
  final double totalPrice;

  CartItem({
    required this.food,
    required this.quantity,
    required this.selectedaddons,
    required this.totalPrice,
  });
}
