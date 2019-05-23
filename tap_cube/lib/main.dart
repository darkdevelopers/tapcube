import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:tap_cube/game/gameview.dart';

void main() async {
  Util flameUtil = new Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  Flame.images.loadAll(<String>[
    'bg/background.png'
  ]);

  GameView gv = new GameView();
  runApp(gv.widget);

  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = gv.onTapDown;
  flameUtil.addGestureRecognizer(tapper);
}
