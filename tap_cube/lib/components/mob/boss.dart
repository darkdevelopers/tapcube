import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:tap_cube/components/mob/ui/lifebar.dart';
import 'package:tap_cube/views/gameview.dart';

class Boss {
  final GameView gv;
  LifeBar mobBar;
  Rect mobRect;
  Sprite mobSprite;
  Sprite mobHitSprite;
  Sprite mobDeadSprite;
  double start = 0;
  bool isDead = false;
  double lootMoney = 0;
  int stage = 0;
  int monsterLevel = 0;
  bool isOffScreen = false;
  bool isHited = false;
  int counter = 0;

  Boss(this.gv, double left, double top, double live, double currentLive, int _stage, int _monsterLevel) {
    isDead = false;
    stage = _stage;
    monsterLevel = _monsterLevel;
    calculateLoot();
    mobBar = LifeBar(gv, live, currentLive);
    mobSprite = Sprite('mobs/boss.png');
    mobHitSprite = Sprite('mobs/boss-hit.png');
    mobDeadSprite = Sprite('mobs/boss-dead.png');
    mobRect = Rect.fromLTWH(left, top, gv.tileSize * 3, gv.tileSize * 3);
  }

  void calculateLoot(){
    lootMoney = (20 * (stage/10+1) * ((monsterLevel*2)/10+1));
  }

  void render(Canvas c) {
    if(isDead){
      mobDeadSprite.renderRect(c, mobRect.inflate(2));
    }else {
      mobSprite.renderRect(c, mobRect.inflate(2));
    }
    mobBar.render(c);
  }

  void update(double t) {
    if(mobBar.currentMobLife <= 0) {
      isDead = true;
      mobRect = mobRect.translate(0, gv.tileSize * 12 * t);
      if(mobRect.top > gv.screenSize.height){
        isOffScreen = true;
      }
    }

    if(isHited){
      mobSprite = Sprite('mobs/boss-hit.png');
      if(counter >= 50) {
        isHited = false;
        counter = 0;
      }
      counter++;
    }else{
      mobSprite = Sprite('mobs/boss.png');
    }
  }
}