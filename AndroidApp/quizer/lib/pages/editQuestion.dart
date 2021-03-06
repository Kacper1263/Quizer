import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quizer/dialogs.dart';
import 'package:quizer/pages/summary.dart';

class EditQuestion extends StatefulWidget {
  @override
  _EditQuestionState createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion>{
  Map data = {};

  TextEditingController questionTextCtrl = new TextEditingController();
  TextEditingController answer1TextCtrl = new TextEditingController();
  TextEditingController answer2TextCtrl = new TextEditingController();
  TextEditingController answer3TextCtrl = new TextEditingController();
  TextEditingController answer4TextCtrl = new TextEditingController();
  TextEditingController goodAnswerTextCtrl = new TextEditingController();
  File image;
  String imageUrl = "null";
  bool loaded;
  bool sended;

  String errorTextAll;
  String errorTextGoodAnswer;

  @override
  void initState() {
    image = null;
    errorTextAll = null;
    errorTextGoodAnswer = null;
    super.initState();
    loaded = false;
    sended = false;
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    if(!loaded){
      loaded = true;
      //? Load old date and show it in fields
      questionTextCtrl.text = data['questionText'];
      answer1TextCtrl.text = data['answer1'];
      answer2TextCtrl.text = data['answer2'];
      answer3TextCtrl.text = data['answer3'];
      answer4TextCtrl.text = data['answer4'];
      goodAnswerTextCtrl.text = data['goodAnswer'];
      if(data['img'] != "null"){
        imageUrl = data['img'] ;        
      }
    }

    return WillPopScope(
      onWillPop: () async => !sended,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit question"),
          centerTitle: true,
          automaticallyImplyLeading: !sended,
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
                          imageUrl = "null";
                        });
                      });
                    },
                    color: Colors.grey[900], shape:
                    RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.white)
                    )
                  ),
                  image == null ? (imageUrl == "null" ? Container() : //Image.network("${data['url']}/api/v1/${data['img']}",
                    // loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                    //   if (loadingProgress == null)
                    //     return child;
                    //   return Center(
                    //     child: CircularProgressIndicator(
                    //       value: loadingProgress.expectedTotalBytes != null
                    //           ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                    //           : null,
                    //     ),
                    //   );
                    // },
                    // )
                    CachedNetworkImage(
                      imageUrl: "${data['url']}/api/v1/${data['img']}",
                      placeholder: (context, url) => Center(child: CircularProgressIndicator(value: null)),
                      errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red, size: 90,),              
                    )
                  ) : Image.file(image), //! If there is not image show empty container
                  image == null && imageUrl == "null" ? Container() : FlatButton.icon(icon: Icon(Icons.delete_forever, color: Colors.white, size: 35,), label: Text("Delete image", style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      setState(() {
                        image = null;
                        imageUrl = "null";
                        print(imageUrl);
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
                        onPressed: sended ? null : () => Navigator.pop(context),
                      ),
                      SizedBox(width: 10),
                      FlatButton(
                        child: sended ? Center(child: CircularProgressIndicator()) : Text("Send",style: TextStyle(color: Colors.white)),
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
                            // check is someone trying to send image through localtunnel
                            bool _continue = false;
                            if(image != null && (data['url'].contains("localtunnel.me") || data['url'].contains("serverless.social")))_continue = await Dialogs.confirmDialog(context, titleText: "Uploading image", descriptionText: "You are trying to upload image to server through localtunnel domain. Keep in mind that you may receive an error due to the localtunnel file size limit! If you encounter a problem while sending a question, try connecting directly to the server by IP address. \n\nDo you want to continue?", onCancel: ()=>Navigator.pop(context,false), onSend: ()=>Navigator.pop(context,true));
                            else _continue = true;
                            if(!_continue) {
                              print(image);
                              Fluttertoast.showToast(msg: "Canceled", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.grey, textColor: Colors.white);
                              return;
                            }
                            
                            setState(() {
                              sended = true;
                            });
                            String base64Image = "null";
                            String fileName = "null";
                            if(image != null){
                              base64Image = base64Encode(image.readAsBytesSync());
                              fileName = image.path.split("/").last;
                            }
                            Fluttertoast.showToast(msg: "Sending, please wait...", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.grey, textColor: Colors.white);
                            try{
                              Response response = await put(data['url'] + "/api/v1/questions/${data['id']}", body: {
                                "id": data['id'].toString(),
                                "question": questionTextCtrl.text,
                                "img": base64Image,
                                "filename": fileName,
                                "answer1": answer1TextCtrl.text,
                                "answer2": answer2TextCtrl.text,
                                "answer3": answer3TextCtrl.text,
                                "answer4": answer4TextCtrl.text,
                                "goodAnswer": goodAnswerTextCtrl.text,
                                "password": data['password'],
                                "oldImg": imageUrl != "null" ? "true" : "false"
                              }).timeout(Duration(seconds: 300));
                              print(response.body);
                              Map responseJson = jsonDecode(response.body);
                              if(responseJson['success'] == "true"){
                                Fluttertoast.showToast(msg: "Success!", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.green, textColor: Colors.white);
                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(context, '/loading', arguments: data['dataForLoading']);
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
      ),
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

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
