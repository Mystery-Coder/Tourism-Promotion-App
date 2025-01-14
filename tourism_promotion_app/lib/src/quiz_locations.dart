import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

const quizURL = "http://127.0.0.1:5500/quiz";

class QuizLocations extends StatefulWidget {
  const QuizLocations({super.key});

  @override
  State<QuizLocations> createState() => _QuizLocationsState();
}

class _QuizLocationsState extends State<QuizLocations> {
  bool isLoaded = false;

  List<dynamic> questions = [];

  int currentQuestionIndex = 0;

  String? selectedOption;

  bool? isAnswerCorrect;

  bool isOptionSelected = false;

  final spinkit = const SpinKitDualRing(
    color: Colors.teal,
    size: 70.0,
  );

  @override
  void initState() {
    super.initState();

    fetchQuiz();
  }

  // Fetch quiz data from the backend

  void fetchQuiz() async {
    try {
      final dio = Dio();

      final response = await dio.get(quizURL);

      setState(() {
        questions = response.data;

        isLoaded = true;
      });
    } catch (error) {
      setState(() {
        isLoaded = false;
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load quiz: $error")),
      );
    }
  }

  // Check if the selected option is correct

  void checkAnswer() {
    final correctAnswer = questions[currentQuestionIndex]['ans'];

    setState(() {
      isAnswerCorrect = (selectedOption == correctAnswer);

      isOptionSelected = true;
    });
  }

  // Move to the next question

  void nextQuestion() {
    if (currentQuestionIndex + 1 < questions.length) {
      setState(() {
        currentQuestionIndex++;

        selectedOption = null; // Reset selected option

        isAnswerCorrect = null; // Reset answer feedback

        isOptionSelected = false; // Enable selection for the next question
      });
    } else {
      // Quiz completion

      setState(() {
        isLoaded = false; // Show completion message instead of quiz
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Identification Quiz"),
        backgroundColor: Colors.teal.shade400,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade200,
              Colors.teal.shade300,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoaded
            ? questions.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Display the image with a perfect-fitting border

                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.teal, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.network(
                              questions[currentQuestionIndex]['imageURL'],
                              height: 250,
                              width: 400,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Text("Image failed to load."),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Display options using radio buttons

                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.teal.shade50, width: 2),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.withOpacity(0.9),
                          ),
                          child: Column(
                            children: questions[currentQuestionIndex]['options']
                                .map<Widget>(
                                  (option) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: RadioListTile<String>(
                                      contentPadding: EdgeInsets
                                          .zero, // Removes default padding

                                      title: Text(
                                        option.replaceAll('_', ' '),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),

                                      value: option,

                                      groupValue: selectedOption,

                                      activeColor: Colors.teal,

                                      onChanged: isOptionSelected
                                          ? null // Disable interaction after selection

                                          : (value) {
                                              setState(() {
                                                selectedOption = value;
                                              });
                                            },
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Display feedback for the selected answer

                        if (isAnswerCorrect != null)
                          Text(
                            isAnswerCorrect! ? "Correct!" : "Incorrect!",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  isAnswerCorrect! ? Colors.green : Colors.red,
                            ),
                          ),

                        const SizedBox(height: 20),

                        // Check Answer Button

                        if (!isOptionSelected)
                          ElevatedButton(
                            onPressed: selectedOption == null
                                ? null
                                : checkAnswer, // Enable only if an option is selected

                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 30),
                              backgroundColor: Colors.teal.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),

                            child: const Text(
                              "Submit Answer",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),

                        // Next Question Button

                        if (isOptionSelected)
                          ElevatedButton(
                            onPressed: nextQuestion,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 30),
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              currentQuestionIndex + 1 < questions.length
                                  ? "Next Question"
                                  : "Finish Quiz",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                      ],
                    ),
                  )
                : const Center(child: Text("No questions available."))
            : Center(
                child: isLoaded
                    ? spinkit
                    : const Text(
                        "Quiz Completed!",
                        style: TextStyle(fontSize: 20, color: Colors.teal),
                      ),
              ),
      ),
    );
  }
}
