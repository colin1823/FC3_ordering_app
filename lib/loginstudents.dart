import 'package:flutter/material.dart';

class Loginstudents extends StatefulWidget {
  const Loginstudents({super.key});

  @override
  State<Loginstudents> createState() => _LoginstudentsState();
}

class _LoginstudentsState extends State<Loginstudents> {
  final TextEditingController studentid=TextEditingController();
  final TextEditingController studentpassword=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:AppBar(backgroundColor: Colors.red,
                   title:Text("Student login"),
                   centerTitle: true,
                   ),
                   body:Column(mainAxisAlignment:MainAxisAlignment.center,
                   children:[
                    Container(child:Image.asset("assets/img/logo.png",
                    height:300)),
                    TextField(controller: studentid,)
                   ])
                    );
  }
}