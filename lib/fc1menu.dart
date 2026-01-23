import 'package:flutter/material.dart';

class Fc1menu extends StatefulWidget {
  const Fc1menu({super.key});

  @override
  State<Fc1menu> createState() => _Fc1menuState();
}

class _Fc1menuState extends State<Fc1menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(child: Text("Sorry, the page is under maintenance. Please take a look at FC3!",
      style:TextStyle(fontSize: 30)),)
    );
  }
}