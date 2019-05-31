import 'dart:convert';
import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:tap_cube/views/gameview.dart';
import 'package:tap_cube/savegame.dart';

void main() async {
  Util flameUtil = new Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);


  SaveGame saveGame = SaveGame();
  String saveGameData = await saveGame.getSaveGame();
  print("running");
  print(saveGameData);
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

  GameView gv = new GameView(saveGame, jsonDecode(saveGameData));
  runApp(gv.widget);

  TapGestureRecognizer tapperGameView = TapGestureRecognizer();
  tapperGameView.onTapDown = gv.onTapDown;
  flameUtil.addGestureRecognizer(tapperGameView);
}
