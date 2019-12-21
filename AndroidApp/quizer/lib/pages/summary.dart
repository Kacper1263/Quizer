import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quizer/question.dart';

class Summary extends StatefulWidget {
  @override
  _SummaryState createState() => _SummaryState();
}

List<Question> questions;
var score;
var questionNow;

class _SummaryState extends State<Summary> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)
        .settings
        .arguments; // received arguments from loading route
    questions = data['questions'];
    score = data["score"];
    questionNow = data["questionNow"];

    var _goodAnswer = questions[questionNow].goodAnswer;
    return Scaffold(
      appBar: AppBar(
        title: Text("Quizer"),
      ),
      body: Container(
        color: Colors.grey[900],
        child: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 40,),
              Text("Summary", style: TextStyle(color: Colors.white, fontSize: 30)),
              SizedBox(height: 20,),
              Text("Your score: " + score.toString() + "/10",style: TextStyle(color: Colors.white, fontSize: 30)),
              SizedBox(height: 20,),
              OutlineButton(
                child: Text("Menu",style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                },
                borderSide: BorderSide(color: Colors.grey[400]),
              ),
            ],
          )
        ]),
      ),
    );
  }
}

