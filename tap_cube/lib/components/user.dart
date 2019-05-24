import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:tap_cube/game/gameview.dart';

class User {
  final GameView gv;
  Rect userRect;
  Sprite userSprite;

  User(this.gv, double left, double top) {
    userSprite = Sprite('user/user.png');
    userRect = Rect.fromLTWH(left, top, gv.tileSize, gv.tileSize);
  }

  void render(Canvas c) {
    userSprite.renderRect(c, userRect.inflate(2));
  }

  void update(double t) {}
}