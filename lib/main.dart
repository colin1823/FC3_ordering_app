import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/page_6_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure you have firebase_options.dart configured

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'FC3 Mobile',
        theme: ThemeData(primarySwatch: Colors.orange),
        home: LoginScreen(),
      ),
    ),
  );
}
