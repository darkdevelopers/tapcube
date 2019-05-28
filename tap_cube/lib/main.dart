import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:tap_cube/views/gameview.dart';

void main() async {
  Util flameUtil = new Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  Flame.images.loadAll(<String>[
    'bg/background.png',
    'user/user.png',
    'mobs/trashmob.png',
    'mobs/goldmob.png',
    'mobs/boss.png',
    'hud/muenze.png'
  ]);

  GameView gv = new GameView();
  runApp(gv.widget);

  TapGestureRecognizer tapperGameView = TapGestureRecognizer();
  tapperGameView.onTapDown = gv.onTapDown;
  flameUtil.addGestureRecognizer(tapperGameView);
}
