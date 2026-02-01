import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileappproject/providers/fooddataservice.dart';
import '../models/models.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  @override
void initState() {
  super.initState();
  loadMenu();
}

void loadMenu() async {
  await Fooddataservice.getallmenus();
  setState(() {}); // refresh UI after loading
}

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Row(
          children:[
            Text("FC3 Food Options by "),
            SizedBox(width:8),
            Image.asset("assets/img/logo.png", height:40),
          ],),),
      body: Column(
        children:[
          const SizedBox(height:10),
          Expanded(
            child:ListView.builder(
              itemCount: Fooddataservice.z.length,
              itemBuilder: (context, index) {
                var food=Fooddataservice.z[index];

                if(food.stock<=0)
                {
                  return const SizedBox.shrink();
                }

                return GestureDetector(
                  onTap: (){
                    Fooddataservice.tappeditem=food.name;
                    Fooddataservice.tappedprice=food.price;
                    Fooddataservice.tappedimage=food.photoUrl;
                    Fooddataservice.tappedid=food.id;
                    Fooddataservice.stallname=food.stallname;

                    if(Fooddataservice.nodifferentstall()==true){
                       if(food.stallname=="miniwok")
                       {
                            Navigator.pushNamed(context, "/page3customization");
                      }
                      else 
                      {
                      CartItem newItem=CartItem(
                        food: food,
                        quantity: 1,
                        selectedaddons: [],
                        totalPrice: food.price,
                      );
                      Fooddataservice.addtocart(newItem);
                      Navigator.pushNamed(context,"/page4cart");
                    }
                    }
                    else
                    {
                      showDialog(
                           context: context,
                           builder: (context) {
                             return AlertDialog(
                                title: Text("Different Stall"),
                                content: Text("Please clear your cart before ordering from another stall."),
                           );
                      });
                    }
                  },
                  child: Card(
                    child: ListTile(
                      leading: Image.asset(food.photoUrl, width:60, height:60, fit:BoxFit.cover),
                      title: Text(food.name),
                      trailing: Text(food.stallname,
                             style:TextStyle(
                              fontSize:15,
                              color: Colors.grey,)),
                      subtitle: Text("\$${food.price.toStringAsFixed(2)}"),
                    ),
                  ),

                );
              }
            ) ,)
        ]
      ),
      bottomNavigationBar: BottomAppBar(child: Text("*You are only allowed to order food from 1 stall at a time",
      style:TextStyle(fontSize:20, color:Colors.black)),),
    );
  }
}   

