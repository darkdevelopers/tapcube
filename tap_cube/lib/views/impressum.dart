import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tap_cube/translation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:connectivity/connectivity.dart';

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
  Future<ConnectivityResult> internetConnectivity;

  String _impressumText = "";

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
    _onImpressumCreated =
        impressumReference.onChildAdded.listen(_onImpressumAdded);
    _onImpressumChanged =
        impressumReference.onChildChanged.listen(_onImpressumUpdate);
  }

  @override
  Widget build(BuildContext context) {
    Text content = Text(
      _impressumText.toString(),
      overflow: TextOverflow.ellipsis,
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