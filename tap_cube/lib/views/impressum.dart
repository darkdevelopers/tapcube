import 'package:flutter/material.dart';

class Impressum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Text content = new Text(
      'TODO need Datenschutz',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontWeight: FontWeight.bold),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Datenschutz"),
      ),
      body: Center(
          child: new Container(
              padding: EdgeInsets.all(10.0),
              child: content
          )
      ),
    );
  }
}