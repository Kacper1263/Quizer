import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController ipController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quizer"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[900],
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            SizedBox(height: 20),
            TextField(
              style: TextStyle(color: Colors.white),
              controller: ipController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[600])),
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
                hintText: 'Enter IP or URL of server',
                hintStyle: TextStyle(color: Colors.grey[500]),
              ),
            ),
            SizedBox(height: 40),
            OutlineButton(
              child: Text("Play", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pushNamed(context, '/loading');
              },
              borderSide: BorderSide(color: Colors.grey[400]),
            ),
            OutlineButton(
              child: Text("Admin panel", style: TextStyle(color: Colors.white)),
              onPressed: () {},
              borderSide: BorderSide(color: Colors.grey[400]),
            )
          ],
        ),
      ),
    );
  }
}
