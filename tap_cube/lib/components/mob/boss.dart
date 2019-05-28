import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:tap_cube/components/mob/ui/lifebar.dart';
import 'package:tap_cube/views/gameview.dart';

class Boss {
  final GameView gv;
  LifeBar mobBar;
  Rect mobRect;
  Sprite mobSprite;
  double start = 0;
  bool isDead = false;
  int lootMoney = 0;

  Boss(this.gv, double left, double top, double live) {
    isDead = false;
    mobBar = LifeBar(gv, live);
    mobSprite = Sprite('mobs/boss.png');
    mobRect = Rect.fromLTWH(left, top, gv.tileSize * 3, gv.tileSize * 3);
  }

  void render(Canvas c) {
    mobSprite.renderRect(c, mobRect.inflate(2));
    mobBar.render(c);
  }

  void update(double t) {
    if(mobBar.currentMobLife <= 0) {
      isDead = true;
    }
  }
}