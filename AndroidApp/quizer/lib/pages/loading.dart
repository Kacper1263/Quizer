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
      setState(() {
        loadingText = "Connecting\nto\nserver";
      });      
      Response response = await get(url+"/api/v1/status").timeout(Duration(seconds: 20));
      Map responseJson = jsonDecode(response.body);
      if(responseJson['success'] == "true"){
        List<Question> _questions;

        setState(() {
          loadingText = "Downloading\nquestions";
        });     

        if(data['all'] != true){ //? Normal situation e.g. game
          var res = await Question.downloadQuestions(url);
          if(res["success"] == true){
            _questions = res["questions"];
            Navigator.pushReplacementNamed(context, "/game", arguments: {"url": url ,"questions": _questions, "score": 0, "questionNow": 0});
          }else{
            Fluttertoast.showToast(msg: "Error: ${res["message"]}", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
            Navigator.pop(context);
          }    
        }
        else{ //? Get all questions e.g for admin panel
          var res = await Question.downloadQuestions(url, all: true);
          if(res["success"] == true){
            _questions = res["questions"];
            Navigator.pushReplacementNamed(context, '/viewAll', arguments: {"url": url ,"questions": _questions, "password": data['password'], "all": true});
          }else{
            Fluttertoast.showToast(msg: "Error: ${res["message"]}", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
            Navigator.pop(context);
          }  
        }
      }   
      else{
        Fluttertoast.showToast(msg: "Bad response from server! Response: $responseJson", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
        Navigator.pop(context);
      }
    }catch(e){
      whatError(e);
      Navigator.pop(context);
    }     
  }

  void loginToPanel() async{
    if(isLoading) return;
    else isLoading = true;

    try{
      //Add http:// if needed
      var url = data["url"].toString();
      var http = url.substring(0,7).toLowerCase();
      var https = url.substring(0,8).toLowerCase();
      if(http != "http://" && https != "https://") url = "http://$url";

      //Test server connection
      setState(() {
        loadingText = "Connecting\nto\nserver";
      });      
      Response response = await get(url+"/api/v1/status").timeout(Duration(seconds: 20));
      Map responseJson = jsonDecode(response.body);
      if(responseJson['success'] == "true"){

        setState(() {
          loadingText = "Logging in";
        });     

        Response response = await post(url+"/api/v1/admin", body: {
          "password": data['password']
        }).timeout(Duration(seconds: 60));
        Map responseJson = jsonDecode(response.body);
        if(responseJson['success'] == "true"){
          Navigator.pushReplacementNamed(context, '/adminPanel', arguments: {"url": url, "password": data['password']});
        }  
        else if(responseJson['success'] == "false"){
          Fluttertoast.showToast(msg: "Error: ${responseJson['message']}", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
          Navigator.pop(context);
        } 
        else{
          Fluttertoast.showToast(msg: "Bad response from server! Response: $responseJson", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
          Navigator.pop(context);
        }            
      }   
      else{
        Fluttertoast.showToast(msg: "Bad response from server! Response: $responseJson", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
        Navigator.pop(context);
      }
    }catch(e){
      whatError(e);
      Navigator.pop(context);
    }     
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments; // received arguments from home route

    if(data['whatToDo'] == "login") loginToPanel();
    else getQuestions();

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

  void whatError(e){
    if(e.toString().startsWith("TimeoutException after")){
      Fluttertoast.showToast(msg: "Can't connect to server! Timed out!", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
    }
    else if(e.toString().startsWith("FormatException")){
      Fluttertoast.showToast(msg: "Format Exception!\n\nProbably connected to IP but can't connect to Quizer server or received html response!", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
    }
    else if(e.toString().startsWith("SocketException")){
      Fluttertoast.showToast(msg: "URL not found!", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
    }
    else if(e.toString().startsWith("type 'int' is not")){
      Fluttertoast.showToast(msg: "Can't connect to server!", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
    }
    else{
      Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
    }
  }
}
