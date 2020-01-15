import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:quizer/dialogs.dart';
import 'package:quizer/pages/game.dart';
import 'package:quizer/question.dart';

class ViewAll extends StatefulWidget {
  @override
  _ViewAllState createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
  Map data = {};
  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    List<Question> questions = data['questions'];
    
    return Scaffold(
      appBar: AppBar(
        title: Text("All questions"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[800],
        child: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Card(
              color: Colors.grey[700],
              child: ListTile(
                title: Text(
                  "${index+1}) ${questions[index].question}",
                  style: TextStyle(fontSize: 23, color: Colors.white)
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.white,
                      onPressed: (){
                        Navigator.pushNamed(context, '/editQuestion', arguments: {
                          "url": data['url'],
                          "id": questions[index].id,
                          "questionText": questions[index].question,
                          "answer1": questions[index].answer1,
                          "answer2": questions[index].answer2,
                          "answer3": questions[index].answer3,
                          "answer4": questions[index].answer4,
                          "goodAnswer": questions[index].goodAnswer,
                          "img": questions[index].img,
                          "password": data['password'],
                          "dataForLoading": data
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_forever),
                      color: Colors.white,
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
                              Response response = await delete(data['url']+"/api/v1/questions/delete/${questions[index].id}", headers: {"password": data['password']}).timeout(Duration(seconds: 60));
                              Map responseJson = jsonDecode(response.body);
                              print(data['password']);

                              if(responseJson['success'] == "true"){
                                Fluttertoast.showToast(msg: "Deleted", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.lightGreen, textColor: Colors.white);
                              }
                              else{
                                Fluttertoast.showToast(msg: "Error: ${responseJson['message']}", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
                              }
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, '/loading', arguments: data);
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
                onTap: () {      // Add 9 lines from here...
                  setState(() {
                    print("Show question ID: ${questions[index].id.toString()}");
                  });
                },
              ),
            );
          }
        )
      ),
    );
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