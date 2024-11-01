import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

const quizURL = "http://127.0.0.1:5500/quiz";

class QuizLocations extends StatelessWidget {
  const QuizLocations({super.key});

  void getQuiz() async {
    final dio = Dio();

    var res = await dio.get(quizURL);
    var data = res.data;

    print(data);
  }

  @override
  Widget build(BuildContext context) {
    getQuiz();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Idenfication Quiz"),
      ),
      body: const Center(
        child: Text("Quiz"),
      ),
    );
  }
}
