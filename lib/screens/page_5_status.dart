import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderStatusScreen extends StatelessWidget {
  final String orderId;
  OrderStatusScreen({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Status")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          var data = snapshot.data!.data() as Map<String, dynamic>;
          String status = data['status'] ?? 'paid';

          // Logic: Visual change on 'ready'
          bool isReady = status == 'ready';

          return AnimatedContainer(
            duration: Duration(seconds: 1),
            color: isReady ? Colors.green.shade100 : Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Order ID: #${orderId.substring(0, 4)}",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 30),
                  _buildStep(
                    "Paid",
                    status == 'paid' ||
                        status == 'preparing' ||
                        status == 'ready',
                  ),
                  _buildLine(),
                  _buildStep(
                    "Preparing",
                    status == 'preparing' || status == 'ready',
                  ),
                  _buildLine(),
                  _buildStep(
                    "Ready to Collect",
                    status == 'ready',
                    isLarge: true,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStep(String label, bool isActive, {bool isLarge = false}) {
    return Column(
      children: [
        Icon(
          isActive ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isActive ? Colors.green : Colors.grey,
          size: isLarge ? 40 : 30,
        ),
        Text(
          label,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: isLarge ? 20 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildLine() => Container(height: 30, width: 2, color: Colors.grey);
}
