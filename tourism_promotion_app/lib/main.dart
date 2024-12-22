import 'package:flutter/material.dart';
import 'package:tourism_promotion_app/src/ai_suggestion.dart';
import 'package:tourism_promotion_app/src/contact_us.dart';
// import 'package:tourism_promotion_app/src/location_details.dart';
import 'package:google_fonts/google_fonts.dart';

import 'src/add_location.dart';
import 'src/home_page.dart';
import 'src/display_locations.dart';
import 'src/quiz_locations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => const HomePage(),
      '/display_locations': (context) => const DisplayLocations(),
      '/quiz': (context) => const QuizLocations(),
      '/add_location_path': (context) => const AddLocation(),
      '/ai_integration': (context) => const AISuggestion(),
      '/contact_us': (context) => const ContactUs(),
      // '/location_details': (context) => const LocationDetails(), //Added as Dynamic Route, as in built when called cuz data needs to be passed
    },
    theme: ThemeData(
      textTheme: GoogleFonts.robotoSerifTextTheme(
        // Provide the default text theme
        ThemeData.light().textTheme,
      ),
    ),
  ));
}
