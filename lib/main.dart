import 'package:flutter/material.dart';
import 'package:mobileappproject/fc1menu.dart';
import 'package:mobileappproject/fc2menu.dart';
import 'package:mobileappproject/fc3menu.dart';
import 'package:mobileappproject/fc4menu.dart';
import 'package:mobileappproject/fc5menu.dart';
import 'package:mobileappproject/fc6menu.dart';
import 'package:mobileappproject/homepage.dart';
import 'package:mobileappproject/loginstudents.dart';
import 'package:mobileappproject/loginvendors.dart';
import 'package:mobileappproject/spmap.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform,
  );
  

  runApp(MaterialApp(
    home:const Homepage(),
    routes:{
      "/spmap":(context)=>Spmap(),
      "/fc1menu":(context)=>Fc1menu(),
      "/fc2menu":(context)=>Fc2menu(),
      "/fc3menu":(context)=>Fc3menu(),
      "/fc4menu":(context)=>Fc4menu(),
      "/fc5menu":(context)=>Fc5menu(),
      "/fc6menu":(context)=>Fc6menu(),
      "/loginvendors":(context)=>Loginvendors(),
      "/loginstudents":(context)=>Loginstudents(),
    }

  ));

}
