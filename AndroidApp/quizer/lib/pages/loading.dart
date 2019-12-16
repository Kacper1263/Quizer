import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../question.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String loadingText = "Downloading\nquestions";

  void getQuestions() async{
    List<Question> _questions = await Question.downloadQuestions();

    Navigator.pushReplacementNamed(context, "/game",
        arguments: {"questions": _questions});
  }

  @override
  void initState() {
    super.initState();
    getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.grey[800],
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SpinKitCubeGrid(
                  color: Colors.white,
                  size: 80,
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  loadingText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
