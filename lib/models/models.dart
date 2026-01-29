import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  final String id;
  final String name;
  final double price;
  final String photoUrl;
  final bool available;
  final String stallId;

  FoodItem({
    required this.id,
    required this.name,
    required this.price,
    required this.photoUrl,
    required this.available,
    required this.stallId,
  });

  factory FoodItem.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FoodItem(
      id: doc.id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      photoUrl:
          data['photoUrl'] ??
          'https://via.placeholder.com/150', // Fallback image
      available: data['available'] ?? true,
      stallId: data['stallId'] ?? '',
    );
  }
}

class CartItem {
  final FoodItem food;
  final int quantity;
  final String customizations;
  final double totalPrice;

  CartItem({
    required this.food,
    required this.quantity,
    required this.customizations,
    required this.totalPrice,
  });
}
