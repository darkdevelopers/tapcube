import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:tap_cube/game/gameview.dart';

class Mob {
  final GameView gv;
  Rect mobRect;
  Sprite mobSprite;

  Mob(this.gv, double left, double top) {
    mobSprite = Sprite('mobs/trashmob.png');
    mobRect = Rect.fromLTWH(left, top, gv.tileSize * 3, gv.tileSize * 3);
  }

  void render(Canvas c) {
    mobSprite.renderRect(c, mobRect.inflate(4));
  }

  void update(double t) {}
}