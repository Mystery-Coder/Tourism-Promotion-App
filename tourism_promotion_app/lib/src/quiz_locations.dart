import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const quizURL = "http://127.0.0.1:5500/quiz";

/* 
  The response of quizURL is of form
  [
    {
      options: [....],
      imageURL: ...,
      ans: ...
    },
    {},
    ...
  ]

*/

class QuizLocations extends StatefulWidget {
  const QuizLocations({super.key});

  @override
  State<QuizLocations> createState() => _QuizLocationsState();
}

class _QuizLocationsState extends State<QuizLocations> {
  bool isLoaded = false;
  var questions = [];
  int questionIdx = 0;

  //Loader for questions
  final spinkit = const SpinKitDualRing(
    color: Color.fromARGB(235, 34, 19, 245),
    size: 70.0,
  );

  //Getting questions
  void getQuiz() async {
    final dio = Dio();

    var res = await dio.get(quizURL);
    var data = res.data;

    setState(() {
      questions = data;
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      getQuiz();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Idenfication Quiz"),
      ),
      body: isLoaded
          ? Center(
              child: Column(
                children: [
                  Image.network(
                    questions[questionIdx]['imageURL'],
                    height: 340,
                    width: 600,
                  )
                ],
              ),
            )
          : spinkit,
    );
  }
}
