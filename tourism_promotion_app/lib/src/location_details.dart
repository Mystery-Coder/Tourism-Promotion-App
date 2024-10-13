import 'package:flutter/material.dart';

class LocationDetails extends StatelessWidget {
  final Map data;
  const LocationDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location Details"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.centerc,
          children: [Text("Distance To You: ${data['dist']} km")],
        ),
      ),
    );
  }
}
