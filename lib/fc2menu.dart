import 'package:flutter/material.dart';

class Fc2menu extends StatefulWidget {
  const Fc2menu({super.key});

  @override
  State<Fc2menu> createState() => _Fc2menuState();
}

class _Fc2menuState extends State<Fc2menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(child: Text("Sorry, the page is under maintenance. Please take a look at FC3!",
      style:TextStyle(fontSize: 30)),)
    );
  }
}