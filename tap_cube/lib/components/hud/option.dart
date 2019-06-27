import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flame/sprite.dart';
import 'package:tap_cube/views/gameview.dart';
import 'package:tap_cube/views/option.dart';

class OptionDisplay {
  final GameView gv;
  Rect optionRect;
  Sprite optionSprite;
  BuildContext context;
  bool isOpen = false;

  OptionDisplay(this.gv, BuildContext _context) {
    optionSprite = Sprite('hud/option.png');
    optionRect = Rect.fromLTWH(0, 10, 100, 100);
    context = _context;
  }

  void render(Canvas c) {
    optionSprite.renderRect(c, optionRect.inflate(2));
  }

  void update(double t) {}

  void onTapDown(){
   // Navigator.of(context).pushNamed('/option');
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new Option()),
    );
    isOpen = true;
  }
}