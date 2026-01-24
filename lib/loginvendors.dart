import 'package:flutter/material.dart';

class Loginvendors extends StatefulWidget {
  const Loginvendors({super.key});

  @override
  State<Loginvendors> createState() => _LoginvendorsState();
}

class _LoginvendorsState extends State<Loginvendors> {
  final TextEditingController vendorid=TextEditingController();
  final TextEditingController vendorpassword=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:AppBar(backgroundColor: Colors.red,
                   title:Text("Vendor login"),
                   centerTitle: true,
                   ),
                   body:Column(mainAxisAlignment:MainAxisAlignment.center,
                   children:[
                    Container(child:Image.asset("assets/img/logo.png",
                    height:300)),
                    TextField(controller: vendorid,)
                   ])
                    );
  }
}