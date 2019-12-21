import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quizer/question.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}
  

class _GameState extends State<Game> {
  Map data = {};

  bool clicked = false;

  List<Question> questions;
  var score;
  var questionNow;

  var btn1Clr = Colors.grey[400];
  var btn2Clr = Colors.grey[400];
  var btn3Clr = Colors.grey[400];
  var btn4Clr = Colors.grey[400];

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty? data : ModalRoute.of(context).settings.arguments; // received arguments from loading route
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
            Image.network("https://images.pexels.com/photos/853199/pexels-photo-853199.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"),
            //Container(color: Colors.white, width: double.infinity, height: 200,), // TODO: Img here
            SizedBox(height: 30),
            OutlineButton(
              child: Text(questions[questionNow].answer1, style: TextStyle(color: Colors.white)),
              onPressed: () {
                checkIsAnswerGoodAndAddScore("1", _goodAnswer);
                loadNext(questionNow, context);
                clicked = true;
              },
              borderSide: BorderSide(color: btn1Clr),
            ),
            OutlineButton(
              child: Text(questions[questionNow].answer2, style: TextStyle(color: Colors.white)),
              onPressed: () {
                checkIsAnswerGoodAndAddScore("2", _goodAnswer);
                loadNext(questionNow, context);
                clicked = true;
              },
              borderSide: BorderSide(color: btn2Clr),
            ),
            OutlineButton(
              child: Text(questions[questionNow].answer3, style: TextStyle(color: Colors.white)),
              onPressed: () {
                checkIsAnswerGoodAndAddScore("3", _goodAnswer);
                loadNext(questionNow, context);
                clicked = true;
              },
              borderSide: BorderSide(color: btn3Clr),
            ),
            OutlineButton(
              child: Text(questions[questionNow].answer4, style: TextStyle(color: Colors.white)),
              onPressed: () {
                checkIsAnswerGoodAndAddScore("4", _goodAnswer);
                loadNext(questionNow, context);
                clicked = true;
              },
              borderSide: BorderSide(color: btn4Clr),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Score: "+ score.toString(), style: TextStyle(color: Colors.white, fontSize: 16)),
                Text("Question: "+ (questionNow + 1).toString() + "/10", style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            )
          ]          
        ),
      ),
    );
  }

  void checkIsAnswerGoodAndAddScore(playerAnswer, goodAnswer){
    if(!clicked){
      if(playerAnswer == goodAnswer) {
        setState(() {
          score++;
          data['score'] = score;
          if(goodAnswer == "1") btn1Clr = Colors.lightGreen;
          if(goodAnswer == "2") btn2Clr = Colors.lightGreen;
          if(goodAnswer == "3") btn3Clr = Colors.lightGreen;
          if(goodAnswer == "4") btn4Clr = Colors.lightGreen;
        });
        Fluttertoast.showToast(msg: "Correct!", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.lightGreen, textColor: Colors.white, gravity: ToastGravity.CENTER, fontSize: 40);
        return;
      }
      else {
        setState(() {
          if(goodAnswer == "1") btn1Clr = Colors.lightGreen;
          if(goodAnswer == "2") btn2Clr = Colors.lightGreen;
          if(goodAnswer == "3") btn3Clr = Colors.lightGreen;
          if(goodAnswer == "4") btn4Clr = Colors.lightGreen;

          if(playerAnswer == "1") btn1Clr = Colors.red;
          if(playerAnswer == "2") btn2Clr = Colors.red;
          if(playerAnswer == "3") btn3Clr = Colors.red;
          if(playerAnswer == "4") btn4Clr = Colors.red;
        });
        Fluttertoast.showToast(msg: "Wrong!", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.red, textColor: Colors.white, gravity: ToastGravity.CENTER, fontSize: 40);
        return;
      }    
    }
  }
  void loadNext(questionNow, context){
    if(!clicked){
      Future.delayed(Duration(seconds: 3),(){
        if(questionNow < 9) {
          questionNow++;
          Navigator.pushReplacementNamed(context, "/game", arguments: {"questions": questions, "score": score, "questionNow": questionNow});
        }else{
          Navigator.pushReplacementNamed(context, "/summary", arguments: {"questions": questions, "score": score, "questionNow": questionNow});
        }  
      });
    }
  }
}
