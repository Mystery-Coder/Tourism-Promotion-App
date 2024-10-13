import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
    // TODO: implement initState
    super.initState();
    locationName = widget.props['locationName'];
    dist = widget.props['dist'];
  }

  void getLocationDetails() async {
    final dio = Dio();
    var res = await dio.get(SERVER_LOCATION_DETAILS_URL + locationName);
    locationDetails = res.data; //dio gives direct JSON

    //Not adding this on init cuz object gets overridden before here
    locationDetails['locationName'] = locationName;
    locationDetails['dist'] = dist;

    print(locationDetails);

    setState(() {
      isLoaded = true;
    });
  }

  //Loader Animation
  final spinkit = const SpinKitCircle(
    color: Color.fromARGB(255, 123, 8, 238),
    size: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      getLocationDetails();
    }

    //Use LocationDetails object to build
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
                    Text('Description: ${locationDetails['desc']}'),
                    Text('Distance To You: ${locationDetails['dist']} km')
                  ],
                ),
              )
            : spinkit);
  }
}
