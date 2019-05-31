import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/painting.dart';
import 'package:tap_cube/views/gameview.dart';

class OptionDisplay {
  final GameView gv;
  Rect optionRect;
  Sprite optionSprite;

  OptionDisplay(this.gv) {
    optionSprite = Sprite('hud/option.png');
    optionRect = Rect.fromLTWH(0, 10, 100, 100);
  }

  void render(Canvas c) {
    optionSprite.renderRect(c, optionRect.inflate(2));
  }

  void update(double t) {}

  void onTapDown(){
    print('click Options');
  }
}