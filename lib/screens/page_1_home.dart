import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'page_2_menu.dart';
import 'page_4_cart.dart';
import 'page_9_history.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LatLng fc3Location = LatLng(1.309, 103.777); // Approx SP Coords
  bool isFarAway = false;

  @override
  void initState() {
    super.initState();
    _checkProximity();
  }

  Future<void> _checkProximity() async {
    // Note: Add location permissions in AndroidManifest.xml/Info.plist
    try {
      Position position = await Geolocator.getCurrentPosition();
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        fc3Location.latitude,
        fc3Location.longitude,
      );
      if (distance > 500) {
        setState(() => isFarAway = true);
      }
    } catch (e) {
      // Handle permission errors silently for demo
    }
  }

  void _handleStallTap(String stallId, String stallName, bool isOpen) {
    if (!isOpen) return;

    final cart = Provider.of<CartProvider>(context, listen: false);

    if (!cart.canOrderFromStall(stallId)) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Different Stall Detected"),
          content: Text(
            "You have items from another stall. Clear cart to order from $stallName?",
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(ctx),
            ),
            TextButton(
              child: Text(
                "Clear & Switch",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                cart.clearCart();
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MenuScreen(stallId: stallId),
                  ),
                );
              },
            ),
          ],
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MenuScreen(stallId: stallId)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FC3 Map"),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => OrderHistoryScreen()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartScreen()),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(center: fc3Location, zoom: 18.0),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              PolygonLayer(
                polygons: [
                  // Example Stall: Chicken Rice (Green/Open)
                  Polygon(
                    points: [
                      LatLng(1.3091, 103.7771),
                      LatLng(1.3092, 103.7772),
                      LatLng(1.3090, 103.7773),
                    ],
                    color: Colors.green.withOpacity(0.6),
                    isFilled: true,
                    label: "Chicken Rice",
                  ),
                ],
              ),
              // Invisible tap layer or MarkerLayer would go here to detect taps on polygons
            ],
          ),
          if (isFarAway)
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(12),
                color: Colors.redAccent,
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "You are >500m away!",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Temporary Debug Button to simulate stall tap since map tap detection is complex
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () =>
                  _handleStallTap('stall_01', 'Chicken Rice', true),
              label: Text("Enter Stall 1"),
              icon: Icon(Icons.store),
            ),
          ),
        ],
      ),
    );
  }
}
