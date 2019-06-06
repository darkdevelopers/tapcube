import 'package:flutter/material.dart';

class Option extends StatefulWidget {
  @override
  State createState() {
    return OptionState();
  }
}

class OptionState extends State<Option> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Option"),
      ),
      body: Text("Body Option"),
    );
  }
}