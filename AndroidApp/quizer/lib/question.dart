import 'dart:convert';

import 'package:http/http.dart';

class Question {
  int id;
  String question; // Actual question
  String img; // Url to image e.g. https://server:8000/img/cat.jpg
  String answer1;
  String answer2;
  String answer3;
  String answer4;
  String goodAnswer;

  Question({this.id, this.question, this.img, this.answer1, this.answer2, this.answer3, this.answer4, this.goodAnswer});

  static Future<List<Question>> downloadQuestions(url) async {
    List<Question> questions = new List<Question>();
    
    //Download and save data from API
    Response response = await get(url+"/api/v1/questions").timeout(Duration(seconds: 60));
    Map responseJson = jsonDecode(response.body);
    
    return questions;
  }
}