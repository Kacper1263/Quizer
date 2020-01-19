import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class AddQuestion extends StatefulWidget {
  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion>{
  Map data = {};

  TextEditingController questionTextCtrl = new TextEditingController();
  TextEditingController answer1TextCtrl = new TextEditingController();
  TextEditingController answer2TextCtrl = new TextEditingController();
  TextEditingController answer3TextCtrl = new TextEditingController();
  TextEditingController answer4TextCtrl = new TextEditingController();
  TextEditingController goodAnswerTextCtrl = new TextEditingController();
  File image;
  bool sended;

  String errorTextAll;
  String errorTextGoodAnswer;

  @override
  void initState() {
    image = null;
    errorTextAll = null;
    errorTextGoodAnswer = null;
    sended = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add question"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[850], //! This must be here 1/2
        child: SingleChildScrollView(
          child: Container(          
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20), //! This must be here 2/2
            child: ListBody(
              children: <Widget>[
                FlatButton.icon(icon: Icon(Icons.image, color: Colors.white, size: 35,), label: Text("Upload image", style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    ImagePicker.pickImage(source: ImageSource.gallery).then((i){
                      setState(() {
                        image = i;  
                      });
                    });
                  },
                  color: Colors.grey[900], shape:
                  RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.white)
                  )
                ),
                image == null ? Container() : Image.file(image), //! If there is not image show empty container
                image == null ? Container() : FlatButton.icon(icon: Icon(Icons.delete_forever, color: Colors.white, size: 35,), label: Text("Delete image", style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    setState(() {
                      image = null;
                    });
                  },
                  color: Colors.grey[900], shape:
                  RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.white)
                  )
                ),
                SizedBox(height: 20),
                Text("Question: ", style: TextStyle(color: Colors.white)),
                SizedBox(height: 10),
                TextField(
                  maxLines: null,
                  style: TextStyle(color: Colors.white),
                  controller: questionTextCtrl,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[600])),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
                    hintText: "E.g.: What is the color of the sky?",
                    errorText: questionTextCtrl.text.isNotEmpty ? null : errorTextAll,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                SizedBox(height: 20),
                Text("Answers: ", style: TextStyle(color: Colors.white)),
                SizedBox(height: 10),
                TextField(
                  //? Answer 1
                  maxLines: null,
                  style: TextStyle(color: Colors.white),
                  controller: answer1TextCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600])),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    hintText: "E.g.: Yellow",
                    errorText: answer1TextCtrl.text.isNotEmpty ? null : errorTextAll,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  //? Answer 2
                  maxLines: null,
                  style: TextStyle(color: Colors.white),
                  controller: answer2TextCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600])),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    hintText: "E.g.: Blue",
                    errorText: answer2TextCtrl.text.isNotEmpty ? null : errorTextAll,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  //? Answer 3
                  maxLines: null,
                  style: TextStyle(color: Colors.white),
                  controller: answer3TextCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600])),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    hintText: "E.g.: Green",
                    errorText: answer3TextCtrl.text.isNotEmpty ? null : errorTextAll,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  //? Answer 4
                  maxLines: null,
                  style: TextStyle(color: Colors.white),
                  controller: answer4TextCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600])),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    hintText: "E.g.: Red",
                    errorText: answer4TextCtrl.text.isNotEmpty ? null : errorTextAll,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                SizedBox(height: 20),
                Text("Good answers (E.g. First... - as number): ",
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: 10),
                TextField(
                  //? Good answer
                  maxLines: null,
                  maxLength: 1,
                  keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                  style: TextStyle(color: Colors.white),
                  controller: goodAnswerTextCtrl,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[600])),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[200])),
                    hintText: "E.g.: 2",
                    errorText: goodAnswerTextCtrl.text.isNotEmpty && isNumeric(goodAnswerTextCtrl.text) && !goodAnswerTextCtrl.text.startsWith('-') && !goodAnswerTextCtrl.text.startsWith('+') && !goodAnswerTextCtrl.text.startsWith('.') && !goodAnswerTextCtrl.text.startsWith(',') && !goodAnswerTextCtrl.text.startsWith(' ') ? (int.parse(goodAnswerTextCtrl.text) >=  1 && int.parse(goodAnswerTextCtrl.text) <=  4 ? null : errorTextGoodAnswer) : errorTextGoodAnswer,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                //? Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Cancel", style: TextStyle(color: Colors.white)),
                      color: Colors.grey[700],
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 10),
                    FlatButton(
                      child: Text("Send",style: TextStyle(color: Colors.white)),
                      color: Colors.lightGreen,
                      onPressed: sended ? null : () async {
                        setState(() {
                          errorTextAll = "This field can't be empty!";
                          errorTextGoodAnswer = "This value must be from 1 to 4";
                        });
                        if(questionTextCtrl.text == "" || answer1TextCtrl.text == "" || answer2TextCtrl.text == "" ||
                          answer3TextCtrl.text == "" || answer4TextCtrl.text == "" || goodAnswerTextCtrl.text == "") 
                        {
                          return;
                        }else{
                          if(
                            goodAnswerTextCtrl.text != "1" &&
                            goodAnswerTextCtrl.text != "2" &&
                            goodAnswerTextCtrl.text != "3" &&
                            goodAnswerTextCtrl.text != "4" 
                          ){
                            return;
                          }
                          sended = true;
                          String base64Image = "null";
                          String fileName = "null";
                          if(image != null){
                            base64Image = base64Encode(image.readAsBytesSync());
                            fileName = image.path.split("/").last;
                          }
                          Fluttertoast.showToast(msg: "Sending, please wait...", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.grey, textColor: Colors.white);
                          try{
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
                            }).timeout(Duration(seconds: 300));
                            print(response.body);
                            Map responseJson = jsonDecode(response.body);
                            if(responseJson['success'] == "true"){
                              Fluttertoast.showToast(msg: "Success!", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.green, textColor: Colors.white);
                              Navigator.pop(context);
                            }
                            else{
                              Fluttertoast.showToast(msg: "Error message: ${responseJson['message']}", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
                            }                                  
                          }catch(e){
                            setState(() {
                              sended = false;
                            });
                            whatError(e);
                          }
                        }
                      }
                    ),
                    SizedBox(width: 10) //? Margin from right
                  ],
                )
              ],
            ),
          ),
        ),
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

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
