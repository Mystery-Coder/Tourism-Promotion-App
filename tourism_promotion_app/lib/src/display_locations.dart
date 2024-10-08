import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart'; // for LatLng

class DisplayLocations extends StatefulWidget {
  const DisplayLocations({super.key});

  @override
  State<DisplayLocations> createState() => _DisplayLocationsState();
}

class _DisplayLocationsState extends State<DisplayLocations> {
  //STATE
  final SERVER_URL =
      'http://127.0.0.1:5500/geo_data_locations'; // Adjust this URL as needed
  bool isLoaded = false;
  Map locationsGeoData = {};
  List<Marker> markersFromServer = [];

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  Future<void> getLocationData() async {
    // User Marker
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationDialog(
          "Location Services Disabled", "Enable Location Services");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      _showLocationDialog(
          "Location Permissions", "Enable Location Permissions Manually");
      return;
    } else if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return; // Permission denied
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _addUserMarker(position.latitude, position.longitude);

    final res = await get(Uri.parse(SERVER_URL));
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      _addLocationMarkers(data);
    }

    setState(() {
      isLoaded = true;
    });
  }

  void _showLocationDialog(String title, String content) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog when pressed
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _addUserMarker(double lat, double lng) {
    Marker userMarker = Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(lat, lng),
      builder: (ctx) => GestureDetector(
        child: const Tooltip(
          message: "You",
          child: Icon(Icons.my_location,
              color: Color.fromARGB(255, 33, 61, 202), size: 40),
        ),
        onTap: () {
          // Handle user marker tap
          print("User marker tapped");
        },
      ),
    );

    markersFromServer.add(userMarker);
  }

  void _addLocationMarkers(Map data) {
    List locationNames = data.keys.toList();
    for (String locationName in locationNames) {
      Marker locationMarker = Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(data[locationName]["lat"], data[locationName]["lng"]),
        builder: (ctx) => GestureDetector(
          child: Tooltip(
            message: locationName,
            child: const Icon(Icons.location_on_outlined,
                color: Colors.red, size: 40),
          ),
          onTap: () {
            _showLocationAlert(locationName); // Show an alert on tap
          },
        ),
      );

      markersFromServer.add(locationMarker);
    }
  }

  void _showLocationAlert(String locationName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(locationName),
          content: Text("This is a location marker for $locationName."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the alert dialog
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  //--------------------------------------------------

  // Loader Animation
  final spinkit = const SpinKitWave(
    color: Color.fromARGB(255, 8, 223, 238),
    size: 50.0,
  );

  //----------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Static Map of Karnataka'),
          backgroundColor: Colors.blue[800],
        ),
        body: isLoaded
            ? FlutterMap(
                options: MapOptions(
                  center: LatLng(14.5204, 75.7224), // Center point of Karnataka
                  zoom: 7, // Adjust zoom level for focusing on Karnataka
                  interactiveFlags: InteractiveFlag.pinchZoom |
                      InteractiveFlag.drag |
                      InteractiveFlag.doubleTapZoom, // Enable gestures
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: markersFromServer, // Add predefined markers
                  ),
                ],
              )
            : Center(child: spinkit), // Center loader
      ),
    );
  }
}
