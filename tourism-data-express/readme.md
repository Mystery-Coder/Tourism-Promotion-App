# Tourism Data Express Server

This Express server supports the **Tourism Promotion App** (Flutter project), providing endpoints for retrieving geographical and quiz data, along with generating creative content through Google Generative AI.

## API Endpoints

### 1. **`GET /`**

-   Test route to verify server is running.

### 2. **`GET /geo_data_locations/:userLat/:userLng`**

-   Returns geo-data for all locations with distances from the provided latitude and longitude.

### 3. **`GET /location_details/:locationName`**

-   Returns details about a specific location, including an image URL.

### 4. **`GET /quiz`**

-   Generates a quiz with random location questions, each containing multiple options and an image.

### 5. **`POST /querygemini`**

-   Accepts a prompt in the request body and returns generated content from Google Generative AI.
