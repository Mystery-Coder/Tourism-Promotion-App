import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Promoting Tourism in Karnataka",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          elevation: 4,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg_img-3.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Text(
                  "Menu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildSidebarButton(
                context,
                title: "View Locations",
                icon: Icons.location_on,
                onPressed: () {
                  Navigator.pushNamed(context, "/display_locations");
                },
              ),
              _buildSidebarButton(
                context,
                title: "Quiz Locations",
                icon: Icons.quiz,
                onPressed: () {
                  Navigator.pushNamed(context, "/quiz");
                },
              ),
              _buildSidebarButton(
                context,
                title: "Add Location",
                icon: Icons.add_location_alt,
                onPressed: () {
                  Navigator.pushNamed(context, "/add_location_path");
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            // Background image with gradient overlay
            DecoratedBox(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_img-3.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // Centered content
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // About Section
                      Card(
                        elevation: 4,
                        color: Colors.white.withOpacity(0.9),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "About This Project",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "The aim of this project is to promote tourism in lesser-known but culturally significant sites in Karnataka.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                """
                                These hidden gems often go unnoticed despite their historical, architectural, and natural beauty. 

                                Our app bridges this gap by providing:
                                - Detailed information about these locations.
                                - Insights into their cultural and historical importance.
                                - A platform for users to share their experiences and reviews.""",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Made by Srikar Rao H M, Subramani M, and Suhas Ravi Shankar",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'u1',
          onPressed: () {
            Navigator.pushNamed(context, "/ai_integration");
          },
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.lightbulb_outline),
        ),
      ),
    );
  }

  Widget _buildSidebarButton(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onPressed}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title),
      onTap: onPressed,
    );
  }
}
