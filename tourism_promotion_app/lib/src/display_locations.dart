import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart'; // for LatLng

class DisplayLocations extends StatefulWidget {
  const DisplayLocations({super.key});

  @override
  State<DisplayLocations> createState() => _DisplayLocationsState();
}

class _DisplayLocationsState extends State<DisplayLocations> {
  //STATE
  final SERVER_URL = 'http://127.0.0.1:5500/';

  Map locationsGeoData = {};

  void getLocationData() async {
    var res = await get(Uri.parse(SERVER_URL));
    var data = jsonDecode(res.body);

    print(data);
  }

  final List<Marker> _markers = [
    Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(12.9716, 77.5946), // Bengaluru (Bangalore)
      builder: (ctx) => GestureDetector(
        child: const Tooltip(
          message: "Bengaluru",
          child: Icon(Icons.location_on_outlined, color: Colors.red, size: 40),
        ),
        onTap: () {
          // print("Bengaluru");
        },
      ),
    ),
    Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(15.3173, 75.7139), // Hubli-Dharwad
      builder: (ctx) =>
          const Icon(Icons.location_on_outlined, color: Colors.green, size: 40),
    ),
    Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(12.2958, 76.6394), // Mysuru (Mysore)
      builder: (ctx) =>
          const Icon(Icons.location_on_outlined, color: Colors.blue, size: 40),
    ),
  ];

  //--------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Static Map of Karnataka'),
          backgroundColor: Colors.blue[800],
        ),
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(14.5204, 75.7224), // Center point of Karnataka
            zoom: 7, // Adjust zoom level for focusing on Karnataka
            interactiveFlags: InteractiveFlag.pinchZoom |
                InteractiveFlag.drag |
                InteractiveFlag.doubleTapZoom, // Disable rotation
          ),
          children: [
            TileLayer(
              urlTemplate:
                  "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: _markers, // Add predefined markers
            ),
          ],
        ),
      ),
    );
  }
}
