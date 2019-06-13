import 'dart:async';
import 'dart:convert';
import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:tap_cube/views/gameview.dart';
import 'package:tap_cube/savegame.dart';
import 'package:tap_cube/views/option.dart';
import 'package:tap_cube/views/impressum.dart';
import 'package:tap_cube/views/datenschutz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:connectivity/connectivity.dart';


void main() {
  runApp(new loadingApp());
}

class loadingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tapcube',
      initialRoute: '/',
      routes: {
        '/': (context) => loadingInformation(),
        '/option': (context) => Option(),
        '/impressum': (context) => Impressum(),
        '/datenschutz': (context) => Datenschutz(),
      },
    );
  }
}

class loadingInformation extends StatefulWidget {
  @override
  State createState() {
    return loadingInformationState();
  }
}

class loadingInformationState extends State<loadingInformation> {
  Widget gv = null;
  Future<ConnectivityResult> internetConnectivity;
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
    checkInternet();
    gameView(context).then((result) {
      setState(() {
        gv = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (gv == null || !isInternetExists) {
      return new Scaffold(); // Splashscreen einfügen
    } else {
      return gv;
    }
  }
}

Future<Widget> gameView(BuildContext context) async {
  Util flameUtil = new Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  SaveGame saveGame = SaveGame();
  String saveGameData = await saveGame.getSaveGame();

  Flame.images.loadAll(<String>[
    'bg/background.png',
    'user/user.png',
    'mobs/trashmob.png',
    'mobs/trashmob-hit.png',
    'mobs/trashmob-dead.png',
    'mobs/goldmob.png',
    'mobs/boss.png',
    'mobs/boss-hit.png',
    'mobs/boss-dead.png',
    'hud/muenze.png',
    'hud/interaction.png',
    'hud/option.png'
  ]);

  GameView gv = new GameView(saveGame, jsonDecode(saveGameData), context);
  flameUtil.addGestureRecognizer(gv.addGesture());
  return gv.widget;
}
