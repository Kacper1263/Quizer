import 'package:flutter/material.dart';
import 'package:quizer/pages/adminPanel.dart';
import 'package:quizer/pages/game.dart';
import 'package:quizer/pages/home.dart';
import 'package:quizer/pages/loading.dart';
import 'package:quizer/pages/summary.dart';

void main() => runApp(MaterialApp(
      title: "Quizer",
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/loading': (context) => Loading(),
        '/game': (context) => Game(),
        '/summary': (context) => Summary(),
        '/adminPanel': (context) => AdminPanel(),
      },
      theme: ThemeData(
        primaryColor: Colors.grey[850],
      ),
    ));
