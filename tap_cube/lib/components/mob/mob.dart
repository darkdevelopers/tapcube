import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:tap_cube/views/gameview.dart';

class Mob {
  final GameView gv;
  Rect mobRect;
  Sprite mobSprite;
  double start = 0;
  double currentLive = 0.0;

  Mob(this.gv, double left, double top, {double live}) {
    mobSprite = Sprite('mobs/trashmob.png');
    mobRect = Rect.fromLTWH(left, top, gv.tileSize * 3, gv.tileSize * 3);
    currentLive = live;
  }

  void render(Canvas c) {
    mobSprite.renderRect(c, mobRect.inflate(2));
  }

  void update(double t) {}
}