import 'package:flutter/material.dart';
import 'package:tap_cube/state/optionstates.dart';
import 'package:url_launcher/url_launcher.dart';

final optionStates _optionStates = optionStates.getInstance();

class Option extends StatefulWidget {
  @override
  OptionState createState() => new OptionState();
}

class OptionState extends State<Option> with AutomaticKeepAliveClientMixin<Option> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tap Cube - Options"),
      ),
      body: ListView(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Allgemeine Informationen', textAlign: TextAlign.center, textScaleFactor: 1.5, style: new TextStyle(color: Colors.black)),
        ),
        ListTile(
          title: Text('Impressum'),
          onTap: (){
            _launchImpressumURL();
          },
          trailing: Icon(Icons.arrow_right),
        ),
        ListTile(
          title: Text('Datenschutz'),
          onTap: (){
            _launchDatenschutzURL();
          },
          trailing: Icon(Icons.arrow_right),
        ),
      ]),
    );
  }

  _launchImpressumURL() async {
    const url = 'https://tapcube.darkdevelopers.de/impressum.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchDatenschutzURL() async {
    const url = 'https://tapcube.darkdevelopers.de/datenschutzerklaerung.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}