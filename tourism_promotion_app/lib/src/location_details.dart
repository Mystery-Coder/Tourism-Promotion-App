// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: constant_identifier_names

// const SERVER_LOCATION_DETAILS_URL =
//     'http://192.168.29.243:5500/location_details/'; //This one is for testing on mobile on localhost

// ignore: constant_identifier_names
const SERVER_LOCATION_DETAILS_URL = 'http://127.0.0.1:5500/location_details/';

class LocationDetails extends StatefulWidget {
  final Map props;
  const LocationDetails({super.key, required this.props});

  @override
  State<LocationDetails> createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  String locationName = '';
  double dist = 0;
  bool isLoaded = false;
  Map locationDetails = {};

  @override
  void initState() {
    super.initState();

    locationName = widget.props['locationName'];
    dist = widget.props['dist'];
  }

  void getLocationDetails() async {
    if (isLoaded) return; // Double guard, prevent unnecessary fetches

    final dio = Dio();
    try {
      // print(SERVER_LOCATION_DETAILS_URL + locationName);
      var res = await dio.get(SERVER_LOCATION_DETAILS_URL + locationName);
      locationDetails = res.data; // Dio gives direct JSON

      locationDetails['locationName'] = locationName;
      locationDetails['dist'] = dist;

      // print(locationDetails);

      setState(() {
        isLoaded = true; // Mark as loaded only after the data is fetched
      });
    } catch (e) {
      print("Error fetching location details: $e");
    }
  }

  //Loader Animation
  final spinkit = const SpinKitCircle(
    color: Color.fromARGB(255, 123, 8, 238),
    size: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    //Use LocationDetails object to build
    if (!isLoaded) {
      getLocationDetails();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "Location Details for ${locationName.replaceAll("_", " ")}"), //Underscores are needed because of URL constraints, but removed wherever user sees locationName

          backgroundColor: const Color.fromARGB(255, 6, 198, 208),
        ),
        body: isLoaded
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.network(
                      locationDetails['imageURL'],
                      width: 700,
                      height: 400,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
                      child: Text(
                        'Description: ${locationDetails['desc']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Distance To You: ${locationDetails['dist']} km',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SelectableText(
                          'Directions: ${locationDetails['maps_link']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.blue,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text: locationDetails['maps_link']));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Copied Link"),
                                duration: Duration(seconds: 1),
                              ));
                            },
                            icon: const Icon(Icons.copy))
                      ],
                    )
                  ],
                ),
              )
            : spinkit);
  }
}
