import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments; // received arguments from loading route
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[900],
        child: ListView(
          padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                      width: 130,
                      child: OutlineButton(
                        child: Text("Add question", style: TextStyle(color: Colors.white, fontSize: 17), textAlign: TextAlign.center,),
                        borderSide: BorderSide(color: Colors.grey[400]),
                        onPressed: () {
                          TextEditingController questionTextCtrl = new TextEditingController();
                          TextEditingController answer1TextCtrl = new TextEditingController();
                          TextEditingController answer2TextCtrl = new TextEditingController();
                          TextEditingController answer3TextCtrl = new TextEditingController();
                          TextEditingController answer4TextCtrl = new TextEditingController();
                          TextEditingController goodAnswerTextCtrl = new TextEditingController();
                          File image;
                          dialogNewQuestion(questionTextCtrl, answer1TextCtrl, answer2TextCtrl, answer3TextCtrl, answer4TextCtrl, goodAnswerTextCtrl, image,
                            onCancel: (){
                              Navigator.pop(context);
                            },
                            onSend: () async {
                              if(
                                questionTextCtrl.text == "" || answer1TextCtrl.text == "" || answer2TextCtrl.text == "" ||
                                answer3TextCtrl.text == "" || answer4TextCtrl.text == "" || goodAnswerTextCtrl.text == ""
                              ) {
                                Fluttertoast.showToast(msg: "You must fill all fields! \nImage is not required.", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
                              }else{
                                String base64Image = "null";
                                String fileName = "null";
                                if(image != null){
                                  base64Image = base64Encode(image.readAsBytesSync());
                                  fileName = image.path.split("/").last;
                                }
                                Fluttertoast.showToast(msg: "Sending, please wait...", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.grey, textColor: Colors.white);
                                Response response = await post(data['url'] + "/api/v1/questions", body: {
                                  "question": questionTextCtrl.text,
                                  "img": base64Image,
                                  "filename": fileName,
                                  "answer1": answer1TextCtrl.text,
                                  "answer2": answer2TextCtrl.text,
                                  "answer3": answer3TextCtrl.text,
                                  "answer4": answer4TextCtrl.text,
                                  "goodAnswer": goodAnswerTextCtrl.text,
                                  "password": data['password']
                                }).timeout(Duration(seconds: 60));
                                Map responseJson = jsonDecode(response.body);
                                if(responseJson['success'] == "true"){
                                  Fluttertoast.showToast(msg: "Success!", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.green, textColor: Colors.white);
                                  Navigator.pop(context);
                                }
                                else{
                                  Fluttertoast.showToast(msg: "Error message: ${responseJson['message']}", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.green, textColor: Colors.white);
                                }
                              }
                            }
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      width: 130,
                      child: OutlineButton(
                        child: Text("View all questions", style: TextStyle(color: Colors.white, fontSize: 17), textAlign: TextAlign.center,),
                        borderSide: BorderSide(color: Colors.grey[400]),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                      width: 130,
                      child: OutlineButton(
                        child: Text("Delete question", style: TextStyle(color: Colors.white, fontSize: 17), textAlign: TextAlign.center,),
                        borderSide: BorderSide(color: Colors.grey[400]),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      width: 130,
                      child: OutlineButton(
                        child: Text("Edit question", style: TextStyle(color: Colors.white, fontSize: 17), textAlign: TextAlign.center,),
                        borderSide: BorderSide(color: Colors.grey[400]),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void dialogNewQuestion(
    TextEditingController questionTextCtrl, 
    TextEditingController answer1TextCtrl, 
    TextEditingController answer2TextCtrl, 
    TextEditingController answer3TextCtrl, 
    TextEditingController answer4TextCtrl, 
    TextEditingController goodAnswerTextCtrl, 
    File image, 
    {onCancel, onSend}) {
    image = null;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Text("Add new question", style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Question: ", style: TextStyle(color: Colors.white)),
                SizedBox(height: 10),
                TextField(
                  maxLines: null,
                  style: TextStyle(color: Colors.white),
                  controller: questionTextCtrl,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600])),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    hintText: "E.g.: What is the color of the sky?",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                SizedBox(height: 10),
                FlatButton.icon(icon: Icon(Icons.image, color: Colors.white, size: 35,), label: Text("Upload image", style: TextStyle(color: Colors.white),), 
                  onPressed: ()async{
                    image = await ImagePicker.pickImage(source: ImageSource.gallery);
                  }, 
                  color: Colors.grey[900], shape: 
                  RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.white)
                  )
                ),
                FlatButton.icon(icon: Icon(Icons.delete_forever, color: Colors.white, size: 35,), label: Text("Delete image", style: TextStyle(color: Colors.white),), 
                  onPressed: (){
                    image = null;
                  }, 
                  color: Colors.grey[900], shape: 
                  RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.white)
                  )
                ),
                SizedBox(height: 10),
                Text("Answers: ", style: TextStyle(color: Colors.white)),
                SizedBox(height: 10),
                TextField( //? Answer 1
                  maxLines: null,
                  style: TextStyle(color: Colors.white),
                  controller: answer1TextCtrl,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600])),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    hintText: "E.g.: Yellow",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                SizedBox(height: 10),
                TextField( //? Answer 2
                  maxLines: null,
                  style: TextStyle(color: Colors.white),
                  controller: answer2TextCtrl,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600])),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    hintText: "E.g.: Blue",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                SizedBox(height: 10),
                TextField( //? Answer 3
                  maxLines: null,
                  style: TextStyle(color: Colors.white),
                  controller: answer3TextCtrl,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600])),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    hintText: "E.g.: Green",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                SizedBox(height: 10),
                TextField( //? Answer 4
                  maxLines: null,
                  style: TextStyle(color: Colors.white),
                  controller: answer4TextCtrl,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600])),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    hintText: "E.g.: Red",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                SizedBox(height: 10),
                Text("Good answers (E.g. First... - as number): ", style: TextStyle(color: Colors.white)),
                SizedBox(height: 10),
                TextField( //? Answer 1
                  maxLines: null,
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  controller: answer1TextCtrl,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600])),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    hintText: "E.g.: 2",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: onCancel,
            ),
            FlatButton(
              child: Text(
                "Send",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightGreen,
              onPressed: onSend,
            )
          ],
        );
      }
    );
  } //? End of dialogNewQuestion()
}
