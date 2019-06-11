import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tap_cube/translation.dart';
import 'package:firebase_database/firebase_database.dart';

final impressumReference = FirebaseDatabase.instance.reference().child(
    'general');


class Impressum extends StatefulWidget {
  @override
  State createState() {
    return ImpressumUi();
  }
}

class ImpressumUi extends State<Impressum> {
  StreamSubscription<Event> _onImpressumChanged;
  StreamSubscription<Event> _onImpressumCreated;

  String _impressumText = "";

  @override
  void initState() {
    super.initState();
    _onImpressumCreated =
        impressumReference.onChildAdded.listen(_onImpressumAdded);
    _onImpressumChanged =
        impressumReference.onChildChanged.listen(_onImpressumUpdate);
  }

  @override
  Widget build(BuildContext context) {
    Text content = Text(
      _impressumText.toString(),
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontWeight: FontWeight.bold),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Impressum'),
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          child: content
      ),
    );
  }

  void _onImpressumAdded(Event event) {
    setState(() {
      _impressumText = this.fromSnapshot(event.snapshot);
    });
  }

  void _onImpressumUpdate(Event event) {
    setState(() {
      _impressumText = this.fromSnapshot(event.snapshot);
    });
  }

  String fromSnapshot(DataSnapshot snapshot) {
    if(snapshot.key == 'impressum') {
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
    return _impressumText;
  }
}