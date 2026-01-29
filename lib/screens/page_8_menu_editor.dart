import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorMenuEditor extends StatelessWidget {
  // Hardcoded for demo; in prod use AuthProvider.userId
  final String stallId = "stall_01";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Inventory")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('stalls')
            .doc(stallId)
            .collection('menu')
            .snapshots(),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, i) {
              var doc = snapshot.data!.docs[i];
              bool isAvailable = doc['available'];

              return SwitchListTile(
                title: Text(doc['name']),
                subtitle: Text(isAvailable ? "In Stock" : "Out of Stock"),
                value: isAvailable,
                onChanged: (val) {
                  // Logic: Instant update to Firestore
                  FirebaseFirestore.instance
                      .collection('stalls')
                      .doc(stallId)
                      .collection('menu')
                      .doc(doc.id)
                      .update({'available': val});
                },
              );
            },
          );
        },
      ),
    );
  }
}
