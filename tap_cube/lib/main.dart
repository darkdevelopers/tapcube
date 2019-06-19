import 'dart:async';
import 'dart:convert';
import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:tap_cube/views/gameview.dart';
import 'package:tap_cube/savegame.dart';
import 'package:tap_cube/views/option.dart';
import 'package:tap_cube/views/impressum.dart';
import 'package:tap_cube/views/datenschutz.dart';

final Util flameUtil = new Util();
final SaveGame saveGame = SaveGame();

String saveGameData;

void main() async {
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

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
    'hud/interaction_disabled.png',
    'hud/option.png'
  ]);

  saveGameData = await saveGame.getSaveGame();

  runApp(
    MaterialApp(
      title: 'Tapcube',
      home: Scaffold(
        body: loadingApp(),
      ),
      routes: {
        '/option': (context) => Option(),
        '/impressum': (context) => Impressum(),
        '/datenschutz': (context) => Datenschutz(),
      },
      debugShowCheckedModeBanner: !kReleaseMode,
    )
  );
}

class loadingApp extends StatelessWidget {
  GameView gv;

  @override
  Widget build(BuildContext context) {
    gv = new GameView(saveGame, jsonDecode(saveGameData), context);
    /*Flame.util.addGestureRecognizer(new TapGestureRecognizer()
    ..onTapDown = (TapDownDetails evt) => print('tap'));*/
    flameUtil.addGestureRecognizer(gv.addGesture());

    return gv.widget;
  }
}

/*class loadingInformation extends StatefulWidget {
  @override
  State createState() {
    return loadingInformationState();
  }
}

class loadingInformationState extends State<loadingInformation> {
  Widget gv = null;

  @override
  void initState() {
    gameView(context).then((result) {
      setState(() {
        gv = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (gv == null) {
      return new Scaffold(
        body: Center(
          child: Text('Loading...')
        ),
      ); // Splashscreen einfügen
    } else {
      return gv;
    }
  }
}*/

/*Future<Widget> gameView(BuildContext context) async {
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
    'hud/interaction_disabled.png',
    'hud/option.png'
  ]);

  GameView gv = new GameView(saveGame, jsonDecode(saveGameData), context);
  flameUtil.addGestureRecognizer(gv.addGesture());
  return gv.widget;
}*/
