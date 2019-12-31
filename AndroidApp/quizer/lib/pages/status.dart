import 'package:flutter/material.dart';

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    String ping = data['ping'].toString();
    String amountOfQuestions = data['amountOfQuestions'].toString();
    String amountOfImages = data['amountOfImages'].toString();
    String imagesSize = data['imagesSize'].toString();

    return Scaffold(
      appBar: AppBar(
        title: Text("Status"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          children: <Widget>[
            Text("Ping: ${ping == "null" ? "N/A" : ping}", style: TextStyle(color: Colors.white, fontSize: 27),),
            Text("Questions: ${amountOfQuestions == "null" ? "N/A" : amountOfQuestions}", style: TextStyle(color: Colors.white, fontSize: 27),),
            Text("Images: ${amountOfImages  == "null" ? "N/A" : amountOfImages}", style: TextStyle(color: Colors.white, fontSize: 27),),
            Text("Images (size): ${imagesSize  == "null" ? "N/A" : imagesSize}", style: TextStyle(color: Colors.white, fontSize: 27),),
          ],
        ),
      ),
    );
  }
}