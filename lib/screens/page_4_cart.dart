import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import 'page_5_status.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    if (_isProcessing) return; // Debouncer logic
    setState(() => _isProcessing = true);

    final cart = Provider.of<CartProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    try {
      // Logic: Create Order Document
      DocumentReference ref = await FirebaseFirestore.instance
          .collection('orders')
          .add({
            'customerId': auth.userId ?? 'guest',
            'stallId': cart.currentStallId,
            'status': 'paid', // Initial status
            'totalAmount': cart.totalAmount,
            'timestamp': FieldValue.serverTimestamp(),
            'items': cart.items
                .map(
                  (item) => {
                    'name': item.food.name,
                    'customizations': item.customizations,
                    'price': item.totalPrice,
                  },
                )
                .toList(),
          });

      cart.clearCart();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OrderStatusScreen(orderId: ref.id)),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error processing order")));
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("My Cart")),
      body: cart.items.isEmpty
          ? Center(child: Text("Your cart is empty."))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.items.length,
                    separatorBuilder: (ctx, i) => Divider(),
                    itemBuilder: (ctx, i) {
                      final item = cart.items[i];
                      return ListTile(
                        title: Text(item.food.name),
                        subtitle: Text(item.customizations),
                        trailing: Text(
                          "\$${item.totalPrice.toStringAsFixed(2)}",
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _processPayment,
                      child: _isProcessing
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Pay \$${cart.totalAmount.toStringAsFixed(2)}",
                            ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
