import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/models.dart';
import 'page_4_cart.dart';

class OrderHistoryScreen extends StatelessWidget {
  final String userId = "user_123"; // Mock ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order History")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('customerId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, i) {
              var data = snapshot.data!.docs[i].data() as Map<String, dynamic>;
              var items = data['items'] as List;

              return ExpansionTile(
                title: Text(
                  "Order on ${(data['timestamp'] as Timestamp).toDate().toString().split('.')[0]}",
                ),
                children: [
                  ...items.map(
                    (item) => ListTile(
                      title: Text(item['name']),
                      subtitle: Text(item['customizations']),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: Text("Reorder This"),
                      onPressed: () {
                        // Logic: Instant Reorder
                        final cart = Provider.of<CartProvider>(
                          context,
                          listen: false,
                        );
                        cart.clearCart(); // Optional: clear existing cart

                        for (var item in items) {
                          // Reconstruct mock FoodItem for reorder
                          FoodItem food = FoodItem(
                            id: 'reorder',
                            name: item['name'],
                            price: item['price'],
                            photoUrl: '',
                            available: true,
                            stallId: data['stallId'],
                          );
                          cart.addToCart(
                            CartItem(
                              food: food,
                              quantity: 1,
                              customizations: item['customizations'],
                              totalPrice: item['price'],
                            ),
                            data['stallId'],
                          );
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CartScreen()),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
