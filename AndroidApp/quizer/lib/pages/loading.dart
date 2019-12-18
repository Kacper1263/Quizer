import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import '../question.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String loadingText = "Loading";
  Map data = {};
  bool isLoading = false;

  void getQuestions() async{
    if(isLoading) return;
    else isLoading = true;

    try{
      //Add http:// if needed
      var url = data["url"].toString();
      var http = url.substring(0,7).toLowerCase();
      var https = url.substring(0,8).toLowerCase();
      if(http != "http://" && https != "https://") url = "http://$url";

      //Test server connection
      loadingText = "Connecting\nto\nserver";
      Response response = await get(url+"/api/v1/status").timeout(Duration(seconds: 60));
      Map responseData = jsonDecode(response.body);
      if(responseData['success'] == "true"){
        List<Question> _questions = await Question.downloadQuestions();
        Navigator.pushReplacementNamed(context, "/game", arguments: {"questions": _questions});
      }   
    }catch(e){
      if(e.toString().startsWith("TimeoutException after")){
        Fluttertoast.showToast(msg: "Can't connect to server! Timed out!", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
      }else{
        Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
      }
      Navigator.pop(context);
    }     
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments; // received arguments from home route

    getQuestions();

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
                    fontSize: 25,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
