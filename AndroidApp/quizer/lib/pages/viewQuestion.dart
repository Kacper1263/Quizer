import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:quizer/question.dart';

import '../dialogs.dart';

class ViewQuestion extends StatefulWidget {
  @override
  _ViewQuestionState createState() => _ViewQuestionState();
}

class _ViewQuestionState extends State<ViewQuestion> {
  Map data = {};
  List<Question> questions;
  var goodAnswer;

  var btn1Clr = Colors.grey[400];
  var btn2Clr = Colors.grey[400];
  var btn3Clr = Colors.grey[400];
  var btn4Clr = Colors.grey[400];

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty? data : ModalRoute.of(context).settings.arguments;
    Question question = data['question'];
    goodAnswer = question.goodAnswer;

    setGoodAnswer();

    return Scaffold(
      appBar: AppBar(
        title: Text("View Question"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            color: Colors.white,
            tooltip: "Edit question",
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/editQuestion', arguments: {
                "url": data['url'],
                "id": question.id,
                "questionText": question.question,
                "answer1": question.answer1,
                "answer2": question.answer2,
                "answer3": question.answer3,
                "answer4": question.answer4,
                "goodAnswer": question.goodAnswer,
                "img": question.img,
                "password": data['password'],
                "dataForLoading": data["dataForLoading"]
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_forever),
            color: Colors.white,
            tooltip: "Delete question",
            onPressed: (){
              Dialogs.confirmDialog(context, titleText: "Confirm delete", descriptionText: "Are you sure you want to delete (forever) this question?",
                onCancel: (){
                  Fluttertoast.showToast(msg: "Canceled", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.grey[700], textColor: Colors.white);
                  Navigator.pop(context);
                },
                onSend: () async {
                  try{
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/loadingScreen', arguments: {"text": "Deleting"});
                    Response response = await delete(data['url']+"/api/v1/questions/delete/${question.id}", headers: {"password": data['password']}).timeout(Duration(seconds: 60));
                    Map responseJson = jsonDecode(response.body);
                    print(data['password']);

                    if(responseJson['success'] == "true"){
                      Fluttertoast.showToast(msg: "Deleted", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.lightGreen, textColor: Colors.white);
                    }
                    else{
                      Fluttertoast.showToast(msg: "Error: ${responseJson['message']}", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/loading', arguments: data["dataForLoading"]);
                  }
                  catch(e){
                    Navigator.pop(context);
                    whatError(e);
                  }
                }
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[900],
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Text(question.question, style: TextStyle(color: Colors.white, fontSize: 30)),
            SizedBox(height: 20),
            question.img == "null" ? Container() : Image.network("${data['url']}/api/v1/${question.img}",
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                if (loadingProgress == null)
                  return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              }
            ),
            SizedBox(height: 30),
            OutlineButton(
              child: Text(question.answer1, style: TextStyle(color: Colors.white)),
              onPressed: () {},
              borderSide: BorderSide(color: btn1Clr),
            ),
            OutlineButton(
              child: Text(question.answer2, style: TextStyle(color: Colors.white)),
              onPressed: () {},
              borderSide: BorderSide(color: btn2Clr),
            ),
            OutlineButton(
              child: Text(question.answer3, style: TextStyle(color: Colors.white)),
              onPressed: () {},
              borderSide: BorderSide(color: btn3Clr),
            ),
            OutlineButton(
              child: Text(question.answer4, style: TextStyle(color: Colors.white)),
              onPressed: () {},
              borderSide: BorderSide(color: btn4Clr),
            ),
            SizedBox(height: 20,)
          ]          
        ),
      ),
    );
  }

  void setGoodAnswer(){
    setState(() {

      if(goodAnswer == "1") btn1Clr = Colors.lightGreen;
      else btn1Clr = Colors.red;
      if(goodAnswer == "2") btn2Clr = Colors.lightGreen;
      else btn2Clr = Colors.red;
      if(goodAnswer == "3") btn3Clr = Colors.lightGreen;
      else btn3Clr = Colors.red;
      if(goodAnswer == "4") btn4Clr = Colors.lightGreen;
      else btn4Clr = Colors.red;
    });
  }

  void whatError(e){
    if(e.toString().startsWith("TimeoutException after")){
      Fluttertoast.showToast(msg: "Can't connect to server! Timed out!", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
    }
    else if(e.toString().startsWith("FormatException")){
      Fluttertoast.showToast(msg: "Format Exception!\n\nProbably connected to IP but can't connect to Quizer server!", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
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