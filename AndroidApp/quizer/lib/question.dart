import 'package:http/http.dart';

class Question {
  String question; // Actual question
  String img; // Url to image e.g. https://server:8000/img/cat.jpg
  String answer1;
  String answer2;
  String answer3;
  String answer4;
  String goodAnswer;

  Question({this.question, this.img, this.answer1, this.answer2, this.answer3, this.answer4, this.goodAnswer});

  static Future<List<Question>> downloadQuestions() async {
    // TODO: Return list of questions from API as List<Question>
    List<Question> questions = new List<Question>();
    questions.add(new Question(question: "Nr1", img: "/1"));
    questions.add(new Question(question: "Nr2", img: "/2"));
    return questions;
  }
}