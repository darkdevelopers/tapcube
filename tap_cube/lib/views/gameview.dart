import 'dart:math';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:tap_cube/components/background.dart';
import 'package:tap_cube/components/user.dart';
import 'package:tap_cube/components/mob/mob.dart';
import 'package:tap_cube/components/mob/boss.dart';
import 'package:tap_cube/components/mob/goldmob.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

const String testDevice = 'IphoneSimulator';

class GameView extends Game {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );

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
  int newGoldMobSpawnTimeStamp;

  GameView() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    background = Background(this);
    goldMobs = List<GoldMob>();
    rng = Random();

    spawnMob();
    spawnUser();

    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);

    analytics = new FirebaseAnalytics();
    observer = new FirebaseAnalyticsObserver(analytics: analytics);

    analytics.logAppOpen();
  }

  void render(Canvas canvas) {
    background.render(canvas);
    mob.render(canvas);
    user.render(canvas);
    goldMobs.forEach((GoldMob goldMob) {
      if(goldMob.newSpawnTime >= DateTime.now().millisecondsSinceEpoch){
        goldMob.render(canvas);
      }
    });
  }

  void update(double t) {
    goldMobs.forEach((GoldMob goldMob) => goldMob.update(t));
    goldMobs.removeWhere((GoldMob goldMob) => goldMob.isOffScreen);
    if(goldMobs.isEmpty){
      spawnGoldMob();
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void loadAds() {
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("RewardedVideoAd event $event");
      if (event == RewardedVideoAdEvent.loaded) {
        RewardedVideoAd.instance.show();
      }
      if (event == RewardedVideoAdEvent.failedToLoad) {
        print("FAILED TO LOAD");
      }
      if (event == RewardedVideoAdEvent.rewarded) {
        //RewardedVideoAd.instance.load(adUnitId: RewardedVideoAd.testAdUnitId);
        print("RewardedVideoAd Amount $rewardAmount");
      }
    };

    RewardedVideoAd.instance.load(
        adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: targetingInfo);
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

  void spawnGoldMob() {
    double top = rng.nextDouble() * (screenSize.height - tileSize);
    goldMobs.add(GoldMob(this, 0.0, top));
  }

  void onTapDown(TapDownDetails d) {
    if(goldMobs.isNotEmpty) {
      goldMobs.forEach((GoldMob goldMob) {
        if (goldMob.mobRect.contains(d.globalPosition)) {
          goldMob.onTapDown(d);
        } else {
          print("make damage");
        }
      });
    }else{
      print("make damage");
    }

    /*analytics.logEvent(name: 'levelup', parameters: <String, dynamic>{
      'int': 1,
    }
    );
    loadAds();*/
  }
}
