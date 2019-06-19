import 'dart:convert';
import 'package:flame/flame.dart';
import 'package:flame/util.dart';
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
var dimension;

void main() async {
  await flameUtil.fullScreen();
  SystemChrome.setEnabledSystemUIOverlays([]);
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);
  dimension = await Flame.util.initialDimensions();

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
    if(saveGameData == null){
      saveGameData = saveGame.blankContant;
      print('Savegame loading error');
    }
    gv = new GameView(saveGame, jsonDecode(saveGameData), context, dimension);
    Flame.util.addGestureRecognizer(gv.addGesture());

    return gv.widget;
  }
}
