import 'package:flutter/material.dart';
import 'package:mobileappproject/providers/fooddataservice.dart';

class Page4Cart extends StatefulWidget {
  const Page4Cart({super.key});

  @override
  State<Page4Cart> createState() => _Page4CartState();
}

class _Page4CartState extends State<Page4Cart> {
  final mycart=Fooddataservice.cart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Row(
          children:[
            Text("My Cart by "),
            SizedBox(width:8),
            Image.asset("assets/img/logo.png", height:40),
          ],
          ),
          ),
          body:Column(children: [
            Expanded(child:
              ListView.builder(
                itemCount: mycart.length,
                itemBuilder: (context, index) {
                  var item=mycart[index];
                  return Card(
                    child: ListTile(
                      leading: Image.asset(item.food.photoUrl, width:60, height:60, fit:BoxFit.cover),
                      title: Text(item.food.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Text("Quantity: ${item.quantity}"),
                          if(item.selectedaddons.isNotEmpty)
                          Text("Add-ons: ${item.selectedaddons.join(", ")}"),
                        ]
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("\$${item.totalPrice.toStringAsFixed(2)}"),
                          const SizedBox(width:10),
                          IconButton(
                            icon: Icon(Icons.delete, color:Colors.red),
                            onPressed: () {
                              setState(() {
                                Fooddataservice.removeat(item);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${item.food.name} removed from cart"),
                                duration: const Duration(milliseconds: 500),)
                              );
                            },
                          )
                        ],
                      ),
                      
                  )
                  );
                },
              ),
            ),
            Padding(padding:const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              children: [
              FilledButton(onPressed: () {
                Navigator.pushNamed(context, "/page2menu");
              }, 
              child: Text("Back to Menu")
              ),
              FilledButton(onPressed: () {
                Navigator.pushNamed(context, "/page9payment");
              }, child: Text("Proceed to Payment")
              ),
              ]),
    )]),
    );
  }
}
   