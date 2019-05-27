import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:tap_cube/views/gameview.dart';

class User {
  final GameView gv;
  Rect userRect;
  Sprite userSprite;
  int currentLevel;
  int currentDamage;
  int currentMoney;

  User(this.gv, double left, double top, int level, int damage, int money) {
    userSprite = Sprite('user/user.png');
    userRect = Rect.fromLTWH(left, top, gv.tileSize, gv.tileSize);
    currentLevel = level;
    currentDamage = damage;
    currentMoney = money;
  }

  void render(Canvas c) {
    userSprite.renderRect(c, userRect.inflate(2));
  }

  void update(double t) {}
}