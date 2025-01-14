// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:tourism_promotion_app/src/home_page.dart'; // for LatLng
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourism_promotion_app/src/location_details.dart';

//URL wouldnt matter if was hosted properly

// const SERVER_URL =
//     'http://192.168.29.243:5500/geo_data_locations'; //This one is for testing on mobile on localhost
const SERVER_URL = 'http://127.0.0.1:5500/geo_data_locations';
const sharedPrefsKeyForLocations = 'LOCATIONS.CACHED';
const sharedPrefKeyForPostion = 'POSITION.CACHED';

class DisplayLocations extends StatefulWidget {
  const DisplayLocations({super.key});

  @override
  State<DisplayLocations> createState() => _DisplayLocationsState();
}

class _DisplayLocationsState extends State<DisplayLocations> {
  //STATE

  bool isLoaded = false;

  List<Marker> markersFromServer = [];

  //Function to deal with repititive alert boxes
  void showAlertForLocation(Widget title, Widget content) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: content,
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()));
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

  void getLocationData() async {
    //Deals with Location Permissions and displaying appropriate alert dialogs
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      //if service is disabled show alert to enable

      showAlertForLocation(const Text("Location Services Disabled"),
          const Text("Enable Location Services"));
    }

    if (permission == LocationPermission.deniedForever) {
      //If denied forever, user must manually update permission
      showAlertForLocation(const Text("Location Permissions"),
          const Text("Enable Location Permissions Manually"));
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.deniedForever) {
        showAlertForLocation(const Text("Location Permissions"),
            const Text("Location Data Access is Needed"));
      }
    }

    //-----------------------------------------------------------------------------------------------
    SharedPreferences prefs = await SharedPreferences.getInstance();

    LatLng position; //Will store user lat long either from cache or geolocator

    var dataPos = prefs.getString(sharedPrefKeyForPostion);

    if (dataPos != null && dataPos != '') {
      //null means, cache hasnt been set for first time
      Map<String, dynamic> positionMap = jsonDecode(dataPos);
      //Construct LatLng object from stored lat lng, cause you cant directly store LatLng Object
      position = LatLng(positionMap['latitude'], positionMap['longitude']);
    } else {
      Position positionFromGeo = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      position = LatLng(positionFromGeo.latitude, positionFromGeo.longitude);

      await prefs.setString(
          sharedPrefKeyForPostion,
          jsonEncode({
            'latitude': position.latitude,
            'longitude': position.longitude
          }));
    }

    // print(position);

    Marker userMarker = Marker(
      width: 80.0,
      height: 80.0,
      point: position,
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
    // ignore: prefer_typing_uninitialized_variables
    var data;

    data = prefs.getString(sharedPrefsKeyForLocations);

    if (data != null && data != '') {
      data = jsonDecode(data);
      // print(data);
    } else {
      // print(
      //     "$SERVER_URL/${position.latitude.toString()}/${position.longitude.toString()}");

      final dio = Dio();
      var res = await dio.get(
          "$SERVER_URL/${position.latitude.toString()}/${position.longitude.toString()}");

      data = res.data; //dio gives direct JSON

      await prefs.setString(sharedPrefsKeyForLocations, jsonEncode(data));
    }

    List locationNames = data.keys.toList();
    double minDist = double.infinity;
    for (String locationName in locationNames) {
      //setting distance of each of location to user

      double d = data[locationName]['userDist'] ?? 0.0;

      // print(data[locationName]);

      if (d < minDist) {
        minDist = d;
      }

      data[locationName]['dist'] = d;
    }

    for (String locationName in locationNames) {
      Marker locationMarker = Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(data[locationName]["lat"],
            data[locationName]["lng"]), // Bengaluru (Bangalore)
        builder: (ctx) => GestureDetector(
          child: Tooltip(
            message: locationName.replaceAll("_",
                " "), //Underscores are needed because of URL constraints, but removed wherever user sees locationName
            child: Icon(Icons.location_on_outlined,
                color: data[locationName]['dist'] == minDist
                    ? Colors.blue
                    : Colors.red,
                size: 40),
          ),
          onTap: () {
            // print(data[locationName]['dist']);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LocationDetails(props: {
                          "locationName": locationName,
                          "dist": data[locationName]['dist']
                        })));
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
            title: const Text('Map of Locations'),
            backgroundColor: Colors.lightBlue[800],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString(sharedPrefKeyForPostion, '');
              await prefs.setString(sharedPrefsKeyForLocations, '');
              // print("Re render");
              setState(() {
                isLoaded = false;
              }); //Call set state to re-render after nulling cache
            },
            tooltip: 'Refresh',
            backgroundColor: Colors.amberAccent,
            child: const Icon(Icons.refresh),
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
