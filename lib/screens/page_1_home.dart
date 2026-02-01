import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobileappproject/providers/fooddataservice.dart';
import 'package:provider/provider.dart';
import 'page_2_menu.dart';
import 'page_4_cart.dart';
import 'page_9_payment.dart';

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
          if (distance > 500) {
            isFarAway = true;
          } else {
            isFarAway = false;
          }
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children:[
            Text("FC3 Map by "),
            SizedBox(width:8),
            Image.asset("assets/img/logo.png", height:30),
          ],
        ),
        actions: [
          //IconButton(icon: Icon(Icons.history), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderHistoryScreen()))),
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Page4Cart()))),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              // Center map on user if available, otherwise FC3
              center: _userLocation ?? fc3Location, 
              initialZoom:  16.8,
              minZoom: 0,
              maxZoom: 20,
            ),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),

              MarkerLayer(markers: [
                    Marker(
                    point: const LatLng(1.30885,103.77818),
                    width: 140,
                    height: 140,
                    child: Column(
                      children: [
                        TextButton(
                          child: const Text("Click to explore FC3 options!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline)),
                          onPressed: () async {
                            await Fooddataservice.getallmenus();
                            if(mounted)
                            {
                                  Navigator.pushNamed(context, '/page2menu');
                            }
                          }
                        ),
                        const Icon(Icons.location_on, size: 30, color: Colors.red),
                      ],
                    )),
                  if(_userLocation!=null)
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
        ],
      ),
      );
  }
}