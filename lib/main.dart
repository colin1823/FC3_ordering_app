import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobileappproject/screens/page_2_menu.dart';
import 'package:provider/provider.dart';
import 'providers/passworddataservice.dart';
import 'firebase_options.dart';
import 'package:mobileappproject/screens/page_1_home.dart';
import 'package:mobileappproject/screens/page_3_customization.dart';
import 'package:mobileappproject/screens/page_4_cart.dart';
import 'package:mobileappproject/screens/page_9_payment.dart';
import 'package:mobileappproject/screens/page_6_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
        home:HomeScreen(),
        routes:{
          "/page1home":(context)=>HomeScreen(),
          "/page2menu":(context)=>MenuScreen(),
          "/page3customization":(context)=>Page3Customization(),
          "/page4cart":(context)=>Page4Cart(),
          "/page9payment":(context)=>Page9Payment(),
         // "/page6auth":(context)=>LoginScreen(),
        }
  )
  );
}
