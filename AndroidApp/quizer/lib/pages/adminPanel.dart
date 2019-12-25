import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  TextEditingController ipController = new TextEditingController();

  TextEditingController adminPassController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                        onPressed: () {},
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

  void dialog(TextEditingController textCtrl,
      {titleText, descriptionText, hintText, onCancel, onSend}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[800],
            title: Text(titleText, style: TextStyle(color: Colors.white)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(descriptionText, style: TextStyle(color: Colors.white)),
                  SizedBox(height: 20),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    controller: textCtrl,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[200])),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[600])),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[200])),
                      hintText: hintText,
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
        });
  }
}
