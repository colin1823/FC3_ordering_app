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
  // Approximate Coordinates for FC3 (Singapore Polytechnic)
  final LatLng fc3Location = LatLng(1.309, 103.777); 
  
  // State to store real-time user location
  LatLng? _userLocation;
  bool isFarAway = false;

  @override
  void initState() {
    super.initState();
    _startLiveLocationUpdates();
  }

  // Logic: Request permission and start listening to the GPS stream
  void _startLiveLocationUpdates() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    // Subscribe to position updates
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10)
    ).listen((Position position) {
      if (mounted) {
        setState(() {
          _userLocation = LatLng(position.latitude, position.longitude);
          
          // Real-time Proximity Check
          double distance = Geolocator.distanceBetween(
            position.latitude, position.longitude, fc3Location.latitude, fc3Location.longitude
          );
          isFarAway = distance > 500; // Warning if > 500m
        });
      }
    });
  }

  void _handleStallTap(String stallId, String stallName, bool isOpen) {
    if (!isOpen) return;

    final cart = Provider.of<CartProvider>(context, listen: false);
    
    if (!cart.canOrderFromStall(stallId)) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Different Stall Detected"),
          content: Text("You have items from another stall. Clear cart to order from $stallName?"),
          actions: [
            TextButton(child: Text("Cancel"), onPressed: () => Navigator.pop(ctx)),
            TextButton(
              child: Text("Clear & Switch", style: TextStyle(color: Colors.red)),
              onPressed: () {
                cart.clearCart();
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => MenuScreen(stallId: stallId)));
              }
            )
          ],
        )
      );
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => MenuScreen(stallId: stallId)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FC3 Map"),
        actions: [
          IconButton(icon: Icon(Icons.history), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderHistoryScreen()))),
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen()))),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              // Center map on user if available, otherwise FC3
              center: _userLocation ?? fc3Location, 
              zoom: 18.0,
            ),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
              
              // Layer 1: Stalls (Polygons)
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: [LatLng(1.3091, 103.7771), LatLng(1.3092, 103.7772), LatLng(1.3090, 103.7773)],
                    color: Colors.green.withOpacity(0.6),
                    isFilled: true,
                    label: "Chicken Rice"
                  ),
                ],
              ),

              // Layer 2: User Location (Marker)
              if (_userLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _userLocation!,
                      width: 50,
                      height: 50,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.8),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(Icons.my_location, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          
          // Proximity Warning Banner
          if (isFarAway)
            Positioned(
              top: 10, left: 10, right: 10,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(child: Text("You are >500m away! Orders may be cold.", style: TextStyle(color: Colors.white))),
                  ],
                ),
              ),
            ),
            
          // Debug/Demo Button (Since clicking polygons on mobile is tricky without gesture setup)
          Positioned(
            bottom: 20, right: 20,
            child: FloatingActionButton.extended(
              onPressed: () => _handleStallTap('stall_01', 'Chicken Rice', true),
              label: Text("Enter Stall 1"),
              icon: Icon(Icons.store),
            ),
          )
        ],
      ),
    );
  }
}