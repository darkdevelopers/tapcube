import 'dart:math';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:tap_cube/components/background.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:tap_cube/firebase/Ads.dart';

class GameView extends Game {
  Size screenSize;
  double tileSize;
  Background background;
  FirebaseAnalytics analytics;
  FirebaseAnalyticsObserver observer;
  Ads ads;

  GameView() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    background = Background(this);
    ads = Ads();

    ads.init();

    analytics = new FirebaseAnalytics();
    observer = new FirebaseAnalyticsObserver(analytics: analytics);

    analytics.logAppOpen();
  }

  void render(Canvas canvas) {
    background.render(canvas);
  }

  void update(double t) {}

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void onTapDown(TapDownDetails d) {
    analytics.logEvent(name: 'levelup', parameters: <String, dynamic>{
        'int': 1,
      }
    );
    ads.loadVideoAds();
  }
}
