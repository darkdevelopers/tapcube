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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
            _optionStates.isOptionDialogOpen = false;
          },
        ),
      ),
      body: ListView(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Allgemeine Informationen', textAlign: TextAlign.center, textScaleFactor: 1.5, style: new TextStyle(color: Colors.black)),
        ),
        ListTile(
          title: Text('Impressum'),
          onTap: (){
            Navigator.of(context).pushNamed('/impressum');
          },
          trailing: Icon(Icons.arrow_right),
        ),
        ListTile(
          title: Text('Datenschutz'),
          onTap: (){
            Navigator.of(context).pushNamed('/datenschutz');
          },
          trailing: Icon(Icons.arrow_right),
        ),
      ]),
    );
  }
}