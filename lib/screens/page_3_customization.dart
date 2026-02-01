import 'package:flutter/material.dart';

class Page3Customization extends StatefulWidget {
  const Page3Customization({super.key});

  @override
  State<Page3Customization> createState() => _Page3CustomizationState();
}

class _Page3CustomizationState extends State<Page3Customization> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Row(
          children:[
            Text("Add ons by "),
            SizedBox(width:8),
            Image.asset("assets/img/logo.png", height:40),
          ],
          ),
          ),
    );
}
}