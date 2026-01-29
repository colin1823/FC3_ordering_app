import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import 'page_3_customization.dart';

class MenuScreen extends StatelessWidget {
  final String stallId;

  MenuScreen({required this.stallId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('stalls')
            .doc(stallId)
            .collection('menu')
            .where(
              'available',
              isEqualTo: true,
            ) // Logic: Filter unavailable items
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No items available currently."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) {
              FoodItem food = FoodItem.fromSnapshot(snapshot.data!.docs[index]);
              return Card(
                child: ListTile(
                  leading: Image.network(
                    food.photoUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(food.name),
                  subtitle: Text("\$${food.price.toStringAsFixed(2)}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CustomizationScreen(food: food),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
