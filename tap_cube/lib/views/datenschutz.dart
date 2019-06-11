import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tap_cube/translation.dart';
import 'package:firebase_database/firebase_database.dart';

final privacyReference = FirebaseDatabase.instance.reference().child(
    'general');

class Datenschutz extends StatefulWidget {
  @override
  State createState() {
    return DatenschutzUi();
  }
}

class DatenschutzUi extends State<Datenschutz>{
  StreamSubscription<Event> _onPrivacyChanged;
  StreamSubscription<Event> _onPrivacyCreated;

  String _privacyText = "";

  @override
  void initState() {
    super.initState();
    _onPrivacyCreated =
        privacyReference.onChildAdded.listen(_onPrivacyAdded);
    _onPrivacyChanged =
        privacyReference.onChildChanged.listen(_onPrivacyUpdate);
  }

  @override
  Widget build(BuildContext context) {

    Text content = Text(
      _privacyText.toString(),
      overflow: TextOverflow.ellipsis,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Datenschutz"),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: content
      ),
    );
  }

  void _onPrivacyAdded(Event event) {
    setState(() {
      _privacyText = this.fromSnapshot(event.snapshot);
    });
  }

  void _onPrivacyUpdate(Event event) {
    setState(() {
      _privacyText = this.fromSnapshot(event.snapshot);
    });
  }

  String fromSnapshot(DataSnapshot snapshot) {
    if(snapshot.key == 'privacyterms') {
      switch (TranslationInformagtions.getLanguage(context)) {
        case 'de': {
          return snapshot.value['de'].toString();
        }
        break;

        case 'en': {
          print(snapshot.value['en'].toString());
          return snapshot.value['en'].toString();
        }
        break;

        default: {
          return snapshot.value['en'].toString();
        }
        break;
      }
    }
    return _privacyText;
  }
}