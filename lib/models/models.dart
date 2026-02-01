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
    name: data['item'] ?? data['name'] ?? 'Unknown',
    price: (data['price'] as num).toDouble(),  
    photoUrl: data['image'] ?? '', 
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

class Userinfo{
  final int id;
  final String password;


  Userinfo({
    required this.id,
    required this.password,
  });

  factory Userinfo.fromSnapshot(DocumentSnapshot doc1) {
    Map<String, dynamic> info = doc1.data() as Map<String, dynamic>;
    return Userinfo(
        id: (info['id'] as int),
        password: (info['password'] as String),
    );
  }
}