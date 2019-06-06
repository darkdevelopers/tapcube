import 'package:flutter/material.dart';
import 'package:tap_cube/state/optionstates.dart';

class Option extends StatefulWidget {
  @override
  State createState() {
    return OptionState();
  }
}

class OptionState extends State<Option> {
  final optionStates _optionStates = optionStates.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tap Cube - Options"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            _optionStates.isOptionDialogOpen = false;
          },
        ),
      ),
      body: Text("Body Option"),
    );
  }
}