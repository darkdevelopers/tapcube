import 'dart:ui';
import 'package:tap_cube/components/mob.dart';
import 'package:flame/sprite.dart';
import 'package:tap_cube/game/gameview.dart';

class Boss extends Mob {
  Boss(GameView gv, double left, double top) : super (gv, left, top) {
    mobSprite = Sprite('mobs/boss.png');
    mobRect = Rect.fromLTWH(left, top, gv.tileSize * 3, gv.tileSize * 3);
  }
}