import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileappproject/models/models.dart';

class Fooddataservice {
  static List<FoodItem> z = [];
  static List<CartItem> cart = [];

  static String tappeditem = "";
  static double tappedprice = 0.0;
  static String tappedimage = "";
  static String tappedid = "";
  static List<dynamic> tappedaddons = [];
  static String stallname="";

  static Future<void> getallmenus() async {
  z.clear();

  QuerySnapshot topDocs = await FirebaseFirestore.instance.collection('stalls').get();

  for (var topDoc in topDocs.docs) {
    List<String> subcollections = ['drinksstore', 'wafflesstore', 'miniwok'];

    for (var sub in subcollections) {
      try {
        var foodsSnapshot = await topDoc.reference.collection(sub).get();
        for (var foodDoc in foodsSnapshot.docs) {
          z.add(FoodItem.fromSnapshot(foodDoc));
        }
      } catch (e) {
        print('Subcollection $sub not found in doc ${topDoc.id}');
      }
    }
  }
  }

  static void addtocart(CartItem newitem) {
    int index = cart.indexWhere((item) => item.food.id == newitem.food.id);
    if (index != -1) {
      cart[index] = CartItem(
        food: newitem.food,
        quantity: cart[index].quantity + 1,
        selectedaddons: cart[index].selectedaddons,
        totalPrice: cart[index].totalPrice + newitem.totalPrice,
      );
    } else {
      cart.add(newitem);
    }
  }

  static double get gettotalprice {
    double total = 0.0;
    for (var item in cart) {
      total += item.totalPrice;
    }
    return total;
  }

  static void removeat(CartItem newitem) {
    int index=cart.indexWhere((item) => item.food.id==newitem.food.id);
    if(index != -1){
      if(cart[index].quantity>1)
      {
        double unitprice=cart[index].totalPrice/cart[index].quantity;
        cart[index]=CartItem(
          food: cart[index].food,
          quantity: cart[index].quantity - 1,
          selectedaddons: cart[index].selectedaddons,
          totalPrice: cart[index].totalPrice - unitprice,
        );
        return;
      }
      else{
        cart.removeAt(index);
      }
      
    }
  }

  static nodifferentstall(){
    if(cart.isEmpty){
      return true;
    }
    else if(cart[0].food.stallname==stallname){
      return true;
    }
    else{
      return false;
    }
  }

}

