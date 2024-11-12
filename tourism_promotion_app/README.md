# Tourism Promotion App

This Flutter app promotes tourism by displaying locations on a map, providing detailed descriptions, and offering a quiz feature. It includes backend integration with an Express server for fetching location data, quiz questions, and geolocation-based functionalities.

## Features

-   **View Locations**: Displays tourist locations on an interactive map of Karnataka with markers.
-   **Location Details**: Provides descriptions and images for each location.
-   **Quiz**: Test knowledge of locations with an interactive quiz.
-   **Add Location**: Allows users to add new locations to the map.

## Key Screens

-   **Home Page**: Navigation to view locations, quiz, and add new locations.
-   **Map View**: Interactive map displaying current and tourism location markers with tooltips and distance indicators.
-   **Quiz Page**: Random questions to identify locations with image hints.

## Dependencies

-   `flutter_map` for map rendering
-   `geolocator` for geolocation
-   `dio` for server communication
-   `shared_preferences` for caching location data

## API Integration

Connects to an Express server (from `tourism_promotion_app`) which provides:

-   **Location Data**: Returns latitudes, longitudes, and descriptions.
-   **Quiz Data**: Supplies random location-based quiz questions.
