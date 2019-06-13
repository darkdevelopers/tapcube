import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tap_cube/translation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:connectivity/connectivity.dart';

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
  Future<ConnectivityResult> internetConnectivity;

  String _privacyText = "";

  bool isInternetExists = false;

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('internet connection problems'),
            content: Text('no internet connection found to sync files'),
            actions: <Widget>[
              FlatButton(
                child: Text('try again'),
                onPressed: () {
                  Navigator.of(context).pop();
                  checkInternet();
                },
              )
            ],
          );
        },
        barrierDismissible: false
    );
  }

  void loadFirebase() {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000);
    FirebaseDatabase.instance
        .reference()
        .child('general')
        .onChildAdded
        .length;
  }

  void checkInternet() {
    ConnectivityResult results;
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      results = result;
      if (ConnectivityResult.mobile == results ||
          ConnectivityResult.wifi == results) {
        loadFirebase();
      }
    });

    Connectivity().checkConnectivity().then((result) {
      results = result;
    }).whenComplete(() {
      if (ConnectivityResult.mobile == results ||
          ConnectivityResult.wifi == results) {
        loadFirebase();

        setState(() {
          isInternetExists = true;
        });
      } else {
        _showDialog();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkInternet();
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