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

  static Future<List<Question>> downloadQuestions() async {
    List<Question> questions = new List<Question>();
    // TODO: Return list of questions from API as List<Question>
    questions.add(new Question(question: "Server connection: OK", img: "/1"));
    return questions;
  }
}