import 'dart:math';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:tap_cube/components/background.dart';
import 'package:tap_cube/components/user.dart';
import 'package:tap_cube/components/mob.dart';
import 'package:tap_cube/components/boss.dart';
import 'package:tap_cube/components/goldmob.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class GameView extends Game {
  Size screenSize;
  double tileSize;
  Background background;
  User user;
  Mob mob;
  Boss boss;
  List<GoldMob> goldMobs;
  FirebaseAnalytics analytics;
  FirebaseAnalyticsObserver observer;
  Random rng;
  int spawnGoldMobDelay;

  GameView() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    background = Background(this);
    goldMobs = List<GoldMob>();
    rng = Random();
    spawnGoldMobDelay = rng.nextInt(600);
    spawnMob();
    spawnUser();

    analytics = new FirebaseAnalytics();
    observer = new FirebaseAnalyticsObserver(analytics: analytics);

    analytics.logAppOpen();
  }

  void render(Canvas canvas) {
    background.render(canvas);
    mob.render(canvas);
    user.render(canvas);
    goldMobs.forEach((GoldMob goldMob) => goldMob.render(canvas));
  }

  void update(double t) {
    goldMobs.forEach((GoldMob goldMob) => goldMob.update(t));
    goldMobs.removeWhere((GoldMob goldMob) => goldMob.isOffScreen);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void spawnUser() {
    user = User(this, ((screenSize.width - tileSize) / 2),
        ((screenSize.height - tileSize) / 1.5));
  }

  void spawnMob() {
    mob = Mob(this, ((screenSize.width - tileSize * 3) / 4),
        ((screenSize.height - tileSize) / 2.1));
  }

  void spawnBoss() {
    boss = Boss(this, ((screenSize.width - tileSize * 3) / 4),
        ((screenSize.height - tileSize) / 2.1));
  }

  void spawnGoldmob() {
    double top = rng.nextDouble() * (screenSize.height - tileSize);
    goldMobs.add(GoldMob(this, 0.0, top));
  }

  void onTapDown(TapDownDetails d) {
    goldMobs.forEach((GoldMob goldMob){
      if(goldMob.mobRect.contains(d.globalPosition)){
        goldMob.onTapDown(d);
        goldMobs.removeWhere((GoldMob goldMob) => goldMob.isTabed);
      }else{
        print("make damage");
      }
    });
    /*analytics.logEvent(name: 'levelup', parameters: <String, dynamic>{
      'int': 1,
    }
    );
    */
  }
}
