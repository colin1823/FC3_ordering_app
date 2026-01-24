import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'dart:convert';



class Spmap extends StatefulWidget {
  const Spmap({super.key});

  @override
  State<Spmap> createState() => _SpmapState();
}

class _SpmapState extends State<Spmap> {
  final MapController mapController=MapController();
  final Location location=Location();
  final TextEditingController locationController=TextEditingController();
  LatLng? currentlocation;
  LatLng? destination;
  List<LatLng> route=[];
  bool isloading=true;

  @override
  @override

  void initState() {
    super.initState();
    initialiselocation();
  }

  Future <void> initialiselocation() async {
    if(!await checktherequestpermissions()) return;

    location.onLocationChanged.listen((LocationData locationdata){
       if(locationdata.latitude!=null && locationdata.longitude!=null) {
        setState((){
             currentlocation=LatLng(locationdata.latitude!,locationdata.longitude!);
             isloading=false;
        });
       }
    });
  }

  Future <void> fetchcoordinatespoint(String location) async {
    final url=Uri.parse("https://nominatim.openstreetmap.org/search?q=$location&format=json&limit=1");
    final response=await http.get(url);
    if(response.statusCode==200){
      final data=json.decode(response.body);
      if(data.isNotEmpty){
        final lat=double.parse(data[0]['lat']);
        final lon=double.parse(data[0]['lon']);
        setState((){
            destination=LatLng(lat,lon);
        });
        await fetchroute();
      } 
      else 
      {
        errormessage("Location not found. Please try another location");
      }
    }
    else
    {
      errormessage("Failed to find location.Try again later");
    }
  }

  Future<bool> checktherequestpermissions() async {
    bool serviceenabled=await location.serviceEnabled();
    if(!serviceenabled)
    {
      serviceenabled=await location.requestService();
      if(!serviceenabled) return false;
    }

    PermissionStatus permissiongranted=await location.hasPermission();
    if(permissiongranted==PermissionStatus.denied)
    {
      permissiongranted=await location.requestPermission();
      if(permissiongranted!=PermissionStatus.granted) return false;
    }
    return true;

  }

  Future <void> userCurrentLocation() async {
    if(currentlocation!=null)
    {
      mapController.move(currentlocation!,15);
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:Text("Current location not available"),
        )
      );
    }
  }

  void errormessage(String message)
  {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
  }

  Future <void> fetchroute() async {
    if(currentlocation==null || destination==null) return;
    final url=Uri.parse("http://router.project-osrm.org/route/v1/driving/"'${currentlocation!.longitude},${currentlocation!.latitude};''${destination!.longitude},${destination!.latitude}?overview=full&geometries=polyline');
    final response=await http.get(url);

    if(response.statusCode==200)
    {
      final data=json.decode(response.body);
      final geometry=data['routes'][0]['geometry'];
      decodepolyline(geometry);
    }
    else
    {
      errormessage("Failed to fetch route.Try again later");
    }
  }

  void decodepolyline(String encodedpolyline)
  {
    PolylinePoints polylinepoints=PolylinePoints();
    List<PointLatLng> decodedpoints=polylinepoints.decodePolyline(encodedpolyline);
    setState((){
         route=decodedpoints
            .map((point)=>LatLng(point.latitude,point.longitude))
            .toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        foregroundColor:Colors.red,
        title:const Text("SP's Foodcourt Map",),
        backgroundColor:Colors.white,
      ),
      body:Stack(
        children:[ FlutterMap(
            mapController: mapController,
            options:MapOptions(
              initialCenter:currentlocation ?? const LatLng(1.3117,103.7759),
              initialZoom:16,
              minZoom:0,
              maxZoom:20,
             ),
             children:[
              TileLayer(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
              ),
              CurrentLocationLayer(
                style:const LocationMarkerStyle(
                  marker:DefaultLocationMarker(
                    child:Icon(
                      Icons.location_pin,
                      color:Colors.white,
                    ),
                  ),
                  markerSize: Size(35,35),
                  markerDirection: MarkerDirection.heading,
                )
              ),
              MarkerLayer(markers: [
                Marker(point:const LatLng(1.30757,103.78138),
                width:80,
                height:80,
                child:Column(children: [
                  TextButton(child:const Text("FC1",
                  style:TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:14,
                    decoration:TextDecoration.underline)),
                  onPressed: () {
                       Navigator.pushNamed(context, '/fc1menu');
                  },
                  ),
                 const Icon(Icons.location_on, size:30, color:Colors.red), 
                ],
                )
                ),
                Marker(point:const LatLng(1.30883,103.78100),
                width:80,
                height:80,
                child:Column(children: [
                  TextButton(child:const Text("FC2",
                  style:TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:14,
                    decoration:TextDecoration.underline)),
                  onPressed: () {
                       Navigator.pushNamed(context, '/fc2menu');
                  },
                  ),
                 const Icon(Icons.location_on, size:30, color:Colors.red), 
                ],
                )),
                Marker(point:const LatLng(1.30892,103.77842),
                width:80,
                height:80,
                child:Column(children: [
                  TextButton(child:const Text("FC3",
                  style:TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:14,
                    decoration:TextDecoration.underline)),
                  onPressed: () {
                      Navigator.pushNamed(context, '/fc3menu');
                  },
                  ),
                 const Icon(Icons.location_on, size:30, color:Colors.red), 
                ],
                )
                ),
                Marker(point:const LatLng(1.31118,103.77711),
                width:80,
                height:80,
                child:Column(children: [
                  TextButton(child:const Text("FC4",
                  style:TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:14,
                    decoration:TextDecoration.underline)),
                  onPressed: () {
                       Navigator.pushNamed(context, '/fc4menu');
                  },
                  ),
                 const Icon(Icons.location_on, size:30, color:Colors.red),   
                ],
                )
                ),
                Marker(point:const LatLng(1.30944,103.77703),
                width:80,
                height:80,
                child:Column(children: [
                  TextButton(child:const Text("FC5",
                  style:TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:14,
                    decoration:TextDecoration.underline)),
                  onPressed: (){
                       Navigator.pushNamed(context, '/fc5menu');
                  },
                  ),
                 const Icon(Icons.location_on, size:30, color:Colors.red),   
                ],
                )
                ),
                Marker(point:const LatLng(1.31113,103.77554),
                width:80,
                height:80,
                child:Column(children: [
                  TextButton(child:const Text("FC6",
                  style:TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:14,
                    decoration:TextDecoration.underline)),
                  onPressed:() {
                       Navigator.pushNamed(context, '/fc6menu');
                  },
                  ),
                 const Icon(Icons.location_on, size:30, color:Colors.red),  
                ],
                )
                )
              ]),
              if(destination!=null)
                MarkerLayer(
                  markers:[
                    Marker(
                      point:destination!,
                      width:80,
                      height:80,
                      child:const Icon(Icons.location_pin,
                      size:40,
                      color:Colors.red,
                      )
                    )
                  ]
                ),
                if(currentlocation!=null && destination !=null && route.isNotEmpty)
      
                  PolylineLayer(polylines: [
                    Polyline(points: route,strokeWidth: 5,color:Colors.red,),
                  ],)
                
             ],
          ),
          Positioned(
            top:0,
            right:0,
            left:0,
            child:Padding(
              padding:const EdgeInsets.all(8.0),
              child:Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller:locationController,
                      decoration:InputDecoration(
                        filled:true,
                        fillColor:Colors.white,
                        hintText:'Enter your desired FC',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal:20),
                      ),
                    ),
                    ),
                    IconButton(
                      style:IconButton.styleFrom(backgroundColor: Colors.white),
                      onPressed: () {
                        final location=locationController.text.trim();
                        if(location.isNotEmpty){
                          fetchcoordinatespoint(location);
                        }
                      },
                      icon:const Icon(Icons.search),
                      )
                ],)
            )
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        elevation:0,
        onPressed:userCurrentLocation,
        backgroundColor: Colors.blue,
        child:const Icon(
          Icons.my_location,size:30,
          color:Colors.white,
        ),
      ),
    );
  }
}
