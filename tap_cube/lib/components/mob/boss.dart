import 'dart:ui';
import 'package:tap_cube/components/mob/mob.dart';
import 'package:flame/sprite.dart';
import 'package:tap_cube/views/gameview.dart';

class Boss extends Mob {
  Boss(GameView gv, double left, double top, double live) : super (gv, left, top, live) {
    mobSprite = Sprite('mobs/boss.png');
    mobRect = Rect.fromLTWH(left, top, gv.tileSize * 3, gv.tileSize * 3);
  }
}