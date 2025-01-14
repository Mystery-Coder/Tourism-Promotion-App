// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    locationName = widget.props['locationName'];
    dist = widget.props['dist'];
    getLocationDetails();
  }

  void getLocationDetails() async {
    if (isLoaded) return; // Prevent unnecessary fetches

    final dio = Dio();
    try {
      var res = await dio.get(SERVER_LOCATION_DETAILS_URL + locationName);
      locationDetails = res.data; // Dio gives direct JSON

      locationDetails['locationName'] = locationName;
      locationDetails['dist'] = dist;

      setState(() {
        isLoaded = true; // Mark as loaded only after the data is fetched
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching location details: $e";
      });
    }
  }

  // Loader Animation
  final spinkit = const SpinKitCircle(
    color: Color.fromARGB(255, 123, 8, 238),
    size: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Location Details for ${locationName.replaceAll("_", " ")}",
        ),
        backgroundColor: const Color.fromARGB(255, 6, 198, 208),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.shade100,
              Colors.teal.shade300,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoaded
            ? Center(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              locationDetails['imageURL'],
                              width: 700,
                              height: 400, // Set a fixed height
                              fit: BoxFit
                                  .cover, // Use BoxFit.cover to fill the space
                              errorBuilder: (context, error, stackTrace) =>
                                  const Text("Image failed to load."),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Description:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            locationDetails['desc'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Distance To You: ${locationDetails['dist']} km',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 20),
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
                                icon: const Icon(Icons.copy),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Center(child: spinkit),
      ),
    );
  }
}
