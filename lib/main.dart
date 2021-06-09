import 'package:flutter/material.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:audioplayers/audio_cache.dart';

import 'quiz_brain.dart';

QuizBrain quizBrain = QuizBrain();

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Widget> scoreKepper = [];
  final player = AudioCache();

  // List<String> questions = [
  //   'Dart is a programming language',
  //   'Flutter is awesome',
  //   'God is human'
  // ];

  // List<bool> answers = [true, true, false];

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getQuestionAnswer();

    if (quizBrain.isFinished()) {
      Alert(
        closeFunction: () {
          setState(() {
            quizBrain.reset();
            scoreKepper.clear();
          });
        },
        context: context,
        title: "Finished!",
        desc: "You've reached the end of the quiz",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              setState(() {
                quizBrain.reset();
                scoreKepper.clear();
                Navigator.pop(context);
              });
            },
            width: 120,
          )
        ],
      ).show();
    } else {
      setState(() {
        if (userPickedAnswer == correctAnswer) {
          scoreKepper.add(Icon(
            Icons.check,
            color: Colors.green,
          ));
          player.play('correct.wav');
        } else {
          scoreKepper.add(Icon(
            Icons.close,
            color: Colors.red,
          ));
          player.play('wrong.wav');
        }

        quizBrain.nextQuestion();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        quizBrain.getQuestionText(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextButton(
                    onPressed: () {
                      checkAnswer(true);
                    },
                    child: Text(
                      'True',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: TextButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextButton(
                    onPressed: () {
                      checkAnswer(false);
                    },
                    child: Text(
                      'False',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: TextButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ),
              ),
              Wrap(
                direction: Axis.horizontal,
                children: scoreKepper,
              )
            ],
          ),
        ),
      ),
    );
  }
}
