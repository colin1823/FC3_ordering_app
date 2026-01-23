import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(backgroundColor: Colors.red,
        title: Text("SP's FC app"),
         centerTitle: true,
         ),
      body:Column(
        children: [
        Container(child: Image.asset("assets/img/logo.png",
        height:300),
         ),
        Container(child:Text("Welcome!",
                  style:TextStyle(fontWeight: FontWeight.w900,
                  fontSize:50
                   ))),
                   const SizedBox(height:80),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
          OutlinedButton(child:Text("Login for vendors"),
          onPressed: () {
               Navigator.pushNamed(context, '/loginvendors');
          },),
          const SizedBox(width:10),
          OutlinedButton(child:Text("Login for students"),
          onPressed: () {
               Navigator.pushNamed(context, '/loginstudents');
          },),

        ])
        
      ],)
    );
  }
}