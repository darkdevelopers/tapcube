import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:tap_cube/views/gameview.dart';
import 'package:tap_cube/savegame.dart';
import 'package:tap_cube/views/option.dart';

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

  runApp(
    MaterialApp(
      title: 'Tapcube',
      home: Scaffold(
        body: loadingApp(),
      ),
      debugShowCheckedModeBanner: !kReleaseMode,
    )
  );
}

class loadingApp extends StatefulWidget {
  @override
  loadingAppState createState() => new loadingAppState();
}

class loadingAppState extends State<loadingApp> with AutomaticKeepAliveClientMixin<loadingApp> {
  @override
  bool get wantKeepAlive => true;

  GameView gv;

  @override
  Widget build(BuildContext context) {
    gv = new GameView(saveGame, context, dimension);
    Flame.util.addGestureRecognizer(gv.addGesture()); // Loading the gesture
    print('loading');
    return gv.widget;
  }
}
