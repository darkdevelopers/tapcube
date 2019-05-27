import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:tap_cube/game/gameview.dart';

class User {
  final GameView gv;
  Rect userRect;
  Sprite userSprite;
  int currentLevel = 1;
  int currentDamage = 1;

  User(this.gv, double left, double top, {int level, int damage}) {
    userSprite = Sprite('user/user.png');
    userRect = Rect.fromLTWH(left, top, gv.tileSize, gv.tileSize);
    currentLevel = level;
    currentDamage = damage;
  }

  void render(Canvas c) {
    userSprite.renderRect(c, userRect.inflate(2));
  }

  void update(double t) {}
}