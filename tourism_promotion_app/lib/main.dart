import 'package:flutter/material.dart';


import 'src/add_location.dart';
import 'src/home_page.dart';
import 'src/display_locations.dart';
import 'src/quiz_locations.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/' : (context) => const HomePage(),
      '/display_locations' : (context) =>  const DisplayLocations(),
      '/quiz' : (context) => const QuizLocations(),
      '/add_location_path': (context) => const AddLocation()
    },
  ));
}