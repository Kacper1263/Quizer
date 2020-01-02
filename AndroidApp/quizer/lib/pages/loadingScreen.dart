import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Map data = {};
  String loadingText;

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    loadingText = data['text'].toString().isNotEmpty ? data['text'] : "Loading";
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
        backgroundColor: Colors.grey[800],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SpinKitCubeGrid(
                color: Colors.white,
                size: 80,
              ),
              SizedBox(height: 24,),
              Text(
                loadingText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,                
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}