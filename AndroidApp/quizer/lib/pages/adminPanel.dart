import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quizer/pages/loadingScreen.dart';

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
                          Navigator.pushNamed(context, '/addQuestion', arguments: {
                            "url": data['url'],
                            "password": data['password']
                          });
                        }
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
                        child: Text("Status", style: TextStyle(color: Colors.white, fontSize: 17), textAlign: TextAlign.center,),
                        borderSide: BorderSide(color: Colors.grey[400]),
                        onPressed: () async {
                          var ping = DateTime.now().millisecond;
                          
                          Navigator.pushNamed(context, '/loadingScreen', arguments: {"text": "Checking\nstatus"});
                          
                          Response response = await get(data['url']+"/api/v1/status").timeout(Duration(seconds: 60));
                          Map responseJson = jsonDecode(response.body);
                          if(responseJson['success'] == "true"){
                            ping = DateTime.now().millisecond - ping;
                            Navigator.pushReplacementNamed(context, '/status', arguments: {
                              "ping": ping.toString() + "ms",
                              "amountOfQuestions": responseJson['amountOfQuestions'],
                              "amountOfImages": responseJson['amountOfImages'],
                              "imagesSize": responseJson['imagesSize']
                            });
                          }
                          else if(responseJson['success'] == "false"){
                            Fluttertoast.showToast(msg: "Error: ${responseJson["message"]}", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
                            Navigator.pop(context);
                          }
                          else{
                            Fluttertoast.showToast(msg: "Error: Bad or no response from server", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
                            Navigator.pop(context);
                          }
                        },
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
}
