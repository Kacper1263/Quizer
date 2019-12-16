import 'package:flutter/material.dart';
import 'package:quizer/pages/home.dart';
import 'package:quizer/pages/loading.dart';

void main() => runApp(MaterialApp(
  title: "Quizer",
  initialRoute: '/',
  routes: {
    '/': (context) => Home(),
    '/loading': (context) => Loading()
  },
  theme: ThemeData(          // Add the 3 lines from here... 
        primaryColor: Colors.grey[850],
  ), 
));

