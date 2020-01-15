import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quizer/dialogs.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController ipController = new TextEditingController();

  TextEditingController adminPassController = new TextEditingController();
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
              keyboardType: TextInputType.visiblePassword,
              style: TextStyle(color: Colors.white),
              controller: ipController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[600])),
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),
                hintText: 'Enter IP or URL:Port of server',
                hintStyle: TextStyle(color: Colors.grey[500]),
              ),
            ),
            SizedBox(height: 40),
            OutlineButton(
              child: Text("Play", style: TextStyle(color: Colors.white)),
              onPressed: () {
                if(ipController.text != "" && ipController.text != null){
                  Navigator.pushNamed(context, '/loading', arguments: {
                    "url": ipController.text
                  });
                }     
                else{
                  Fluttertoast.showToast(msg: "You must provide URL of server!", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
                }           
              },
              borderSide: BorderSide(color: Colors.grey[400]),
            ),
            OutlineButton(
              child: Text("Admin panel", style: TextStyle(color: Colors.white)),
              onPressed: () {
                if(ipController.text != "" && ipController.text != null){
                  Dialogs.oneInputDialog(adminPassController, context, titleText: "Admin password", descriptionText: "Provide admin password to login", hintText: "E.g. 1423",
                    onCancel: (){
                      Fluttertoast.showToast(msg: "Canceled", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.grey[700], textColor: Colors.white);
                      Navigator.pop(context);  
                    },
                    onSend: () {                    
                      if(adminPassController.text == "") {
                        Fluttertoast.showToast(msg: "You need to provide password!", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
                        return;
                      }
                      Navigator.pop(context);  
                      Navigator.pushNamed(context, '/loading', arguments: {
                        "url": ipController.text,
                        "password": adminPassController.text,
                        "whatToDo": "login"
                      });
                    },
                    sendText: "Login"
                  );                  
                }     
                else{
                  Fluttertoast.showToast(msg: "You must provide URL of server!", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, textColor: Colors.white);
                }   
              },
              borderSide: BorderSide(color: Colors.grey[400]),
            )
          ],
        ),
      ),
    );
  }
}
