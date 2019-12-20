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

  Question(
      {this.id,
      this.question,
      this.img,
      this.answer1,
      this.answer2,
      this.answer3,
      this.answer4,
      this.goodAnswer});

  static Future<Map> downloadQuestions(url) async {
    List<Question> questions = new List<Question>();

    //Download and save data from API
    Response response = await get(url + "/api/v1/questions").timeout(Duration(seconds: 60));
    Map responseJson = jsonDecode(response.body);
    List questionsFromAPI = responseJson["content"];
    questionsFromAPI.forEach((q) {
      questions.add(new Question(
          id: q["id"],
          question: q["question"],
          img: q["img"],
          answer1: q["answer1"],
          answer2: q["answer2"],
          answer3: q["answer3"],
          answer4: q["answer4"],
          goodAnswer: q["goodAnswer"]
      ));
    });

    if (responseJson['success'] != "true") {
      if (responseJson['message'] != null) {
        return {"success": false, "message": responseJson["message"]};
      } else {
        return {
          "success": false,
          "message": "Unknown error while downloading questions"
        };
      }
    }

    return {"success": true, "questions": questions};
  }
}
