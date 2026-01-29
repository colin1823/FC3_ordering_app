import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/cart_provider.dart';

class CustomizationScreen extends StatefulWidget {
  final FoodItem food;
  CustomizationScreen({required this.food});

  @override
  _CustomizationScreenState createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends State<CustomizationScreen> {
  // Logic: Options state
  bool noSpringOnion = false;
  bool noChilli = false;
  bool addEgg = false;

  double get currentPrice {
    double total = widget.food.price;
    if (addEgg) total += 0.50;
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.food.name)),
      body: Column(
        children: [
          Image.network(
            widget.food.photoUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Customize Order",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                CheckboxListTile(
                  title: Text("No Spring Onion"),
                  value: noSpringOnion,
                  onChanged: (val) => setState(() => noSpringOnion = val!),
                ),
                CheckboxListTile(
                  title: Text("No Chilli"),
                  value: noChilli,
                  onChanged: (val) => setState(() => noChilli = val!),
                ),
                SwitchListTile(
                  title: Text("Add Egg (+\$0.50)"),
                  value: addEgg,
                  onChanged: (val) => setState(() => addEgg = val),
                ),
              ],
            ),
          ),
          // Logic: Dynamic Price Label & Cart Addition
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${currentPrice.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    List<String> customs = [];
                    if (noSpringOnion) customs.add("No Spring Onion");
                    if (noChilli) customs.add("No Chilli");
                    if (addEgg) customs.add("Add Egg");

                    Provider.of<CartProvider>(context, listen: false).addToCart(
                      CartItem(
                        food: widget.food,
                        quantity: 1,
                        customizations: customs.isEmpty
                            ? "Standard"
                            : customs.join(", "),
                        totalPrice: currentPrice,
                      ),
                      widget.food.stallId,
                    );
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Text("Add to Cart"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
