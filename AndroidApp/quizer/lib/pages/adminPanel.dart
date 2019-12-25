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
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Column(children: <Widget>[
              OutlineButton(
                onPressed: null,
                child: Text("Add Question", style: TextStyle(),),
              )
            ],
            )
          ],
        ),
      ),
    );
  }


  void dialog(TextEditingController textCtrl, {titleText, descriptionText, hintText, onCancel, onSend}){    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Text(titleText ,style: TextStyle(color: Colors.white)),            
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(descriptionText ,style: TextStyle(color: Colors.white)),
                SizedBox(height: 20),
                TextField(
                  style: TextStyle(
                    color: Colors.white
                  ),
                  controller: textCtrl,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[600])),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
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
              child: Text("Send", style: TextStyle(color: Colors.white),),
              color: Colors.lightGreen,
              onPressed: onSend,
            )
          ],
        );
      }
    );
  }
}
