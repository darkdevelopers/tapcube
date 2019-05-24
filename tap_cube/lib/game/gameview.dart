import 'dart:math';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:tap_cube/components/background.dart';
import 'package:tap_cube/components/user.dart';
import 'package:tap_cube/components/mob.dart';
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
  FirebaseAnalytics analytics;
  FirebaseAnalyticsObserver observer;

  GameView() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    background = Background(this);

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
  }

  void update(double t) {}

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
    user = User(this, ((screenSize.width - tileSize) / 2), ((screenSize.height - tileSize) / 1.5));
  }

  void spawnMob() {
    mob = Mob(this, ((screenSize.width - tileSize * 3) / 2), ((screenSize.height - tileSize) / 1.8));
  }

  void onTapDown(TapDownDetails d) {
    print("make damage");
    /*analytics.logEvent(name: 'levelup', parameters: <String, dynamic>{
      'int': 1,
    }
    );
    loadAds();*/
  }
}
