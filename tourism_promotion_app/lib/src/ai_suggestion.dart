import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AISuggestion extends StatefulWidget {
  const AISuggestion({super.key});

  @override
  State<AISuggestion> createState() => _AISuggestionState();
}

class _AISuggestionState extends State<AISuggestion> {
  final TextEditingController _controller = TextEditingController();
  String _aiResponse = "";
  bool _isLoading = false; // Flag to track loading state

  // Function to remove Markdown from the response text
  String _stripMarkdown(String markdown) {
    final RegExp markdownRegExp = RegExp(
      r'\*{1,2}|_+|~+|\[.*?\]\(.*?\)|\n', // Matches Markdown symbols and links
      multiLine: true,
    );
    return markdown.replaceAll(
        markdownRegExp, ''); // Removes all Markdown formatting
  }

  Future<void> getAIResponse() async {
    setState(() {
      _isLoading = true; // Set loading to true when starting the request
      _aiResponse = ""; // Clear previous response
    });

    try {
      final response = await Dio().post(
        'http://localhost:5500/querygemini', // Update with your server URL if needed
        data: {'prompt': _controller.text},
      );
      setState(() {
        // Clean the response from Markdown and assign it to _aiResponse
        _aiResponse = _stripMarkdown(response.data['output'] ?? '');
        _isLoading = false; // Set loading to false after receiving the response
      });
    } catch (error) {
      setState(() {
        _aiResponse = "Error: Unable to get response from AI.";
        _isLoading = false; // Set loading to false in case of an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Query AI"),
        backgroundColor: Colors.red.shade400, // Change app bar color
      ),
      body: Center(
        // Center the whole content vertically and horizontally
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.8, // Limiting width to 80% of screen
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText:
                      "Ask AI about a tourism location or recommendation...",
                  border: UnderlineInputBorder(),
                ),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: getAIResponse,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Colors.red.shade400), // Button color
              ),
              child: const Text(
                "Get AI Suggestion",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            // If loading, show a spinner, else show the AI response
            if (_isLoading) ...[
              SpinKitDoubleBounce(
                color: Colors.red.shade400, // Spinner color
                size: 50.0, // Spinner size
              ),
            ],
            if (!_isLoading && _aiResponse.isNotEmpty) ...[
              const Text(
                "AI Suggestion:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Display the cleaned AI response as plain text
              Container(
                padding: const EdgeInsets.all(8),
                width: 900,
                child: Text(
                  _aiResponse,
                  style: const TextStyle(
                    fontSize: 14, // Adjust font size as needed
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
