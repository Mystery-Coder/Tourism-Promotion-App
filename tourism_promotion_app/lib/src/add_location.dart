// ignore_for_file: use_build_context_synchronously, constant_identifier_names

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
      body: Container(
        color: Colors.grey[200], // Background color
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Enter Location Details",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: nameC,
                      hintText: "Location Name",
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: urlC,
                      hintText: "Latitude, Longitude URL",
                      icon: Icons.map,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: descC,
                      hintText: "Description",
                      icon: Icons.description,
                      maxLines: null,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.amber, // Button background color
                        foregroundColor: Colors.black87, // Text color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Add"),
                      onPressed: () async {
                        // Logic to send data to the server
                        try {
                          final dio = Dio();
                          final res = await dio.post(SERVER_URL, data: {
                            "name": nameC.text,
                            "url": urlC.text,
                            "desc": descC.text
                          });

                          if (res.statusCode == 200) {
                            // Clear the text fields after successful submission
                            nameC.clear();
                            urlC.clear();
                            descC.clear();

                            // Show success message
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Added New Location"),
                            ));
                          } else {
                            // Show error message if the response is not 200
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Failed to add location"),
                            ));
                          }
                        } catch (e) {
                          // Handle any errors that occur during the request
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Error: $e"),
                          ));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    int? maxLines,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.amber),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.amber),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.amber, width: 2),
        ),
      ),
      maxLines: maxLines,
    );
  }
}
