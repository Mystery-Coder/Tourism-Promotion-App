// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

const SERVER_URL = 'http://127.0.0.1:5500/add_location';

class _AddLocationState extends State<AddLocation> {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController urlC = TextEditingController();
  final TextEditingController descC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Location"),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter Location Name:"),
            SizedBox(
              width: 400,
              child: TextField(
                controller: nameC,
                decoration: InputDecoration(
                    hintText: "Location Name", border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: 45,
            ),
            Text("Enter Maps URL with Latitude and Longitude:"),
            SizedBox(
              width: 400,
              child: TextField(
                controller: urlC,
                decoration: InputDecoration(
                    hintText: "Latitude, Longitude URL",
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: 45,
            ),
            Text("Describe The Place"),
            SizedBox(
              width: 400,
              child: TextField(
                controller: descC,
                decoration: InputDecoration(
                    hintText: "Description", border: OutlineInputBorder()),
                maxLines: null,
              ),
            ),
            SizedBox(
              height: 45,
            ),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black87),
              child: Text("Add"),
              onPressed: () async {
                // print(nameC.text + " " + urlC.text + " " + descC.text);
                final dio = Dio();
                final res = await dio.post(SERVER_URL, data: {
                  "name": nameC.text,
                  "url": urlC.text,
                  "desc": descC.text
                });

                if (res.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Added New Location"),
                  ));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
