import 'package:flutter/material.dart';
// import 'package:tourism_promotion_app/src/location_details.dart';

import 'src/add_location.dart';
import 'src/home_page.dart';
import 'src/display_locations.dart';
import 'src/quiz_locations.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => const HomePage(),
      '/display_locations': (context) => const DisplayLocations(),
      '/quiz': (context) => const QuizLocations(),
      '/add_location_path': (context) => const AddLocation(),
      // '/location_details': (context) => const LocationDetails(), //Added as Dynamic Route, as in built when called
    },
  ));
}
