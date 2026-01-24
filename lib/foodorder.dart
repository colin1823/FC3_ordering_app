import 'package:cloud_firestore/cloud_firestore.dart';

class Foodorder {
   static String tappedfood="";
   static String tappedaddons="";

  static CollectionReference food=FirebaseFirestore.instance.collection('fc3');
}