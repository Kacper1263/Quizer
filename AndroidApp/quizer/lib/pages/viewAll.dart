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
                  "${questions[index].id}) ${questions[index].question}",
                  style: TextStyle(fontSize: 23, color: Colors.white)
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.white,
                      onPressed: (){
                        print("Edit question ID: ${questions[index].id.toString()}");
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
}