import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:tap_cube/views/gameview.dart';

class User {
  final GameView gv;
  Rect userRect;
  Sprite userSprite;
  Rect userDamageRect;
  Sprite userDamageSprite;
  Rect moneyRect;
  Sprite moneySprite;
  int currentDamage;

  User(this.gv, double left, double top, int damage) {
    userSprite = Sprite('user/user.png');
    userRect = Rect.fromLTWH(left, top, gv.tileSize, gv.tileSize);
    userDamageSprite = Sprite('hud/interaction.png');
    userDamageRect = Rect.fromLTWH((gv.screenSize.width - gv.tileSize) / 2.25, (gv.screenSize.height - gv.tileSize) / 1.25, gv.tileSize * 2.5, gv.tileSize*1.25);
    moneySprite = Sprite('hud/muenze.png');
    moneyRect = Rect.fromLTWH(((gv.screenSize.width - gv.tileSize) / 2), ((gv.screenSize.height - gv.tileSize) / 1.245), 20, 20);
    currentDamage = damage;
  }

  void render(Canvas c) {
    userSprite.renderRect(c, userRect.inflate(2));
    userDamageSprite.renderRect(c, userDamageRect);
    moneySprite.renderRect(c, moneyRect);
  }

  void update(double t) {}
}