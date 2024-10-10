import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:tourism_promotion_app/src/home_page.dart'; // for LatLng
import 'package:shared_preferences/shared_preferences.dart';

// const SERVER_URL = 'http://192.168.29.243:5500/geo_data_locations'; //This one is for testing on mobile on localhost
//URL wouldnt matter if was hosted properly
// ignore: constant_identifier_names
const SERVER_URL = 'http://127.0.0.1:5500/geo_data_locations';
const sharedPrefsKey = 'LOCATIONS.CACHED';

class DisplayLocations extends StatefulWidget {
  const DisplayLocations({super.key});

  @override
  State<DisplayLocations> createState() => _DisplayLocationsState();
}

class _DisplayLocationsState extends State<DisplayLocations> {
  //STATE

  bool isLoaded = false;

  Map locationsGeoData = {};
  List<Marker> markersFromServer = [];

  void getLocationData() async {
    //Deals with Location Permissions and displaying appropriate alert dialogs
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      //if service is disabled show alert to enable
      showDialog(
        context: context,
        barrierDismissible:
            false, // Prevents dismissing the dialog by tapping outside
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Location Services Disabled"),
            content: const Text("Enable Location Services"),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomePage()));
                  setState(() {});
                  return; // Close the dialog when pressed
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    }

    if (permission == LocationPermission.deniedForever) {
      //If denied forever, user must manually update permission
      showDialog(
        context: context,
        barrierDismissible:
            false, // Prevents dismissing the dialog by tapping outside
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Location Permissions"),
            content: const Text("Enable Location Permissions Manually"),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomePage()));
                  setState(() {});
                  return; // Close the dialog when pressed
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.deniedForever) {
        showDialog(
          context: context,
          barrierDismissible:
              false, // Prevents dismissing the dialog by tapping outside
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Location Permissions"),
              content: const Text("Location Data Access is Needed"),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomePage()));
                    setState(() {});
                  },
                  child: const Text("Close"),
                ),
              ],
            );
          },
        );
      }
    }

    //-----------------------------------------------------------------------------------------------
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // print(position);

    Marker userMarker = Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(position.latitude, position.longitude),
      builder: (ctx) => GestureDetector(
        child: const Tooltip(
          message: "You",
          child: Icon(Icons.my_location,
              color: Color.fromARGB(255, 33, 61, 202), size: 40),
        ),
        onTap: () {},
      ),
    );

    markersFromServer.add(userMarker);
    //Let location data be fetched on each render, but other markers use SharedPrefs
    var data;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    data = prefs.getString(sharedPrefsKey);

    if (data != null) {
      data = jsonDecode(data);
      // print(data);
    } else {
      final dio = Dio();
      var res = await dio.get(SERVER_URL);
      data = res.data;

      await prefs.setString(sharedPrefsKey, jsonEncode(data));
    }

    List locationNames = data.keys.toList();
    // print(locationNames);

    for (String locationName in locationNames) {
      Marker locationMarker = Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(data[locationName]["lat"],
            data[locationName]["lng"]), // Bengaluru (Bangalore)
        builder: (ctx) => GestureDetector(
          child: Tooltip(
            message: locationName,
            child: const Icon(Icons.location_on_outlined,
                color: Colors.red, size: 40),
          ),
          onTap: () {
            print(locationName);
          },
        ),
      );

      markersFromServer.add(locationMarker);
    }

    setState(() {
      isLoaded = true;
    });
  }

  //--------------------------------------------------

  //Loader Animation
  final spinkit = const SpinKitWave(
    color: Color.fromARGB(255, 8, 223, 238),
    size: 50.0,
  );

  //----------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      //The build method is called on every render so, get the data only if its not loaded
      getLocationData();
    }

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Static Map of Karnataka'),
            backgroundColor: Colors.blue[800],
          ),
          body: isLoaded
              ? FlutterMap(
                  options: MapOptions(
                    center:
                        LatLng(14.5204, 75.7224), // Center point of Karnataka
                    zoom: 7, // Adjust zoom level for focusing on Karnataka
                    interactiveFlags: InteractiveFlag.pinchZoom |
                        InteractiveFlag.drag |
                        InteractiveFlag.doubleTapZoom, // Disable rotation
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: markersFromServer, // Add predefined markers
                    ),
                  ],
                )
              : spinkit),
    );
  }
}

// final List<Marker> _markers = [
//     Marker(
//       width: 80.0,
//       height: 80.0,
//       point: LatLng(12.9716, 77.5946), // Bengaluru (Bangalore)
//       builder: (ctx) => GestureDetector(
//         child: const Tooltip(
//           message: "Bengaluru",
//           child: Icon(Icons.location_on_outlined, color: Colors.red, size: 40),
//         ),
//         onTap: () {
//           // print("Bengaluru");
//         },
//       ),
//     ),
//     Marker(
//       width: 80.0,
//       height: 80.0,
//       point: LatLng(15.3173, 75.7139), // Hubli-Dharwad
//       builder: (ctx) =>
//           const Icon(Icons.location_on_outlined, color: Colors.green, size: 40),
//     ),
//     Marker(
//       width: 80.0,
//       height: 80.0,
//       point: LatLng(12.2958, 76.6394), // Mysuru (Mysore)
//       builder: (ctx) =>
//           const Icon(Icons.location_on_outlined, color: Colors.blue, size: 40),
//     ),
//   ];
