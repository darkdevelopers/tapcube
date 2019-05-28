import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:tap_cube/views/gameview.dart';
import 'package:tap_cube/firebase/Ads.dart';
import 'package:tap_cube/components/mob/mob.dart';
import 'package:flutter/gestures.dart';

class GoldMob extends Mob {
  int newSpawnTime = 0;
  int minDelay = 5;
  int maxDelay = 10;
  bool isOffScreen = false;
  bool isTabed = false;
  bool isSpawned = false;
  Ads ads;
  Offset targetLocation;
  double get speed => gv.tileSize * 0.5;

  GoldMob(GameView gv, double left, double top, double live) : super (gv, left, top, live) {
    isSpawned = true;
    int delay = minDelay + gv.rng.nextInt(maxDelay - minDelay);
    Duration duration = Duration(minutes: delay);
    newSpawnTime = DateTime.now().add(duration).millisecondsSinceEpoch;
    start = left;
    mobSprite = Sprite('mobs/goldmob.png');
    mobRect = Rect.fromLTWH(left, top, gv.tileSize, gv.tileSize);
    ads = Ads();
    ads.init();

    setTargetLocation();
  }

  void setTargetLocation() {
    double left = start *
        (gv.screenSize.width - (gv.tileSize * 2.025));
    double top = gv.rng.nextDouble() *
        (gv.screenSize.height - (gv.tileSize * 1.025));
    targetLocation = Offset(left, mobRect.top);
  }

  @override
  void render(Canvas c) {
    mobSprite.renderRect(c, mobRect.inflate(10));
  }

  @override
  void update(double t) {
    double stepDistance = speed * t;
    Offset toTarget = targetLocation - Offset(mobRect.left, mobRect.top);
    Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
    if(mobRect.left < gv.screenSize.width) {
      start += 0.1;
    }else{
      isOffScreen = true;
    }
    mobRect = mobRect.shift(stepToTarget);
    setTargetLocation();
  }

  void onTapDown(TapDownDetails d) {
    //load dialog
    isTabed = true;
    ads.loadVideoAds();
  }
}