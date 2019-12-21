import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quizer/question.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}
  
  List<Question> questions;
  var score;
  var questionNow;

class _GameState extends State<Game> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments; // received arguments from loading route
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
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Text(questions[questionNow].question, style: TextStyle(color: Colors.white, fontSize: 30)),
            SizedBox(height: 20),
            Container(color: Colors.white, width: double.infinity, height: 200,), // TODO: Img here
            SizedBox(height: 30),
            OutlineButton(
              child: Text(questions[questionNow].answer1, style: TextStyle(color: Colors.white)),
              onPressed: () {
                checkIsAnswerGoodAndAddScore("1", _goodAnswer);
                loadNext(questionNow, context);
              },
              borderSide: BorderSide(color: Colors.grey[400]),
            ),
            OutlineButton(
              child: Text(questions[questionNow].answer2, style: TextStyle(color: Colors.white)),
              onPressed: () {
                checkIsAnswerGoodAndAddScore("2", _goodAnswer);
                loadNext(questionNow, context);
              },
              borderSide: BorderSide(color: Colors.grey[400]),
            ),
            OutlineButton(
              child: Text(questions[questionNow].answer3, style: TextStyle(color: Colors.white)),
              onPressed: () {
                checkIsAnswerGoodAndAddScore("3", _goodAnswer);
                loadNext(questionNow, context);
              },
              borderSide: BorderSide(color: Colors.grey[400]),
            ),
            OutlineButton(
              child: Text(questions[questionNow].answer4, style: TextStyle(color: Colors.white)),
              onPressed: () {
                checkIsAnswerGoodAndAddScore("4", _goodAnswer);
                loadNext(questionNow, context);
              },
              borderSide: BorderSide(color: Colors.grey[400]),
            ),
            SizedBox(height: 10,),
            Text("Score: "+ score.toString(), style: TextStyle(color: Colors.white, fontSize: 16)),
          ]          
        ),
      ),
    );
  }
}

bool checkIsAnswerGoodAndAddScore(playerAnswer, goodAnswer){
  if(playerAnswer == goodAnswer) {
    score++;
    Fluttertoast.showToast(msg: "Correct!", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.lightGreen, textColor: Colors.white, gravity: ToastGravity.CENTER, fontSize: 50);
    return true;
  }
  else {
    Fluttertoast.showToast(msg: "Wrong!", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.red, textColor: Colors.white, gravity: ToastGravity.CENTER, fontSize: 50);
    return false;
  }
}
void loadNext(questionNow, context){
  if(questionNow < 9) {// 10 - 1
    questionNow++;
    Navigator.pushReplacementNamed(context, "/game", arguments: {"questions": questions, "score": score, "questionNow": questionNow});
  }else{
    Navigator.pushReplacementNamed(context, "/summary", arguments: {"questions": questions, "score": score, "questionNow": questionNow});
  }
}