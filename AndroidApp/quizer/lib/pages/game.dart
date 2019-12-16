import 'package:flutter/material.dart';
import 'package:quizer/question.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  Map data = {};

  List<Question> questions;

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments; // received arguments from loading route
    questions = data['questions'];
    print(questions);
    
    return Scaffold(
      appBar: AppBar(title: Text("Quizer"),),

    );
  }
}