import 'package:flutter/material.dart';
import 'package:quizer/pages/game.dart';
import 'package:quizer/question.dart';

class ViewAll extends StatefulWidget {
  @override
  _ViewAllState createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
  Map data = {};
  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    List<Question> questions = data['questions'];
    
    return Scaffold(
      appBar: AppBar(
        title: Text("All questions"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[800],
        child: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Card(
              color: Colors.grey[700],
              child: ListTile(
                title: Text(
                  "${questions[index].id}) ${questions[index].question}",
                  style: TextStyle(fontSize: 23, color: Colors.white)
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.white,
                      onPressed: (){
                        print("Edit question ID: ${questions[index].id.toString()}");
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_forever),
                      color: Colors.white,
                      onPressed: (){
                        print("Delete question ID: ${questions[index].id.toString()}");
                      },
                    ),
                  ],
                ),
                onTap: () {      // Add 9 lines from here...
                  setState(() {
                    print("Show question ID: ${questions[index].id.toString()}");
                  });
                },
              ),
            );
          }
        )
      ),
    );
  }
}