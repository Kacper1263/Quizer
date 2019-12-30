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
}
