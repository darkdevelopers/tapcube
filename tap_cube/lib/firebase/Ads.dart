import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

import 'package:tap_cube/components/mob/goldmob.dart';

const String testDevice = 'IphoneSimulator';

class Ads {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>[
      'idle',
      'best games',
      'games',
      'fun games',
      'play free online games',
      'play games',
      'top games'
    ],
    childDirected: true,
    nonPersonalizedAds: true,
  );

  static const MobileAdTargetingInfo targetingInfoRelease = MobileAdTargetingInfo();

  void init() {
      FirebaseAdMob.instance.initialize(appId: getAppId());
  }

  void loadVideoAds(GoldMob goldMob) {
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
        goldMob.isRewardedVideo = true;
      }
    };
    RewardedVideoAd.instance.load(adUnitId: getAdUnitId(), targetingInfo: targetingInfoRelease);
  }

  String getAdUnitId() {
    return Platform.isAndroid
        ? 'ca-app-pub-8089412545634153/6410165060'
        : 'ca-app-pub-8089412545634153/5863370155';
  }

  String getAppId() {
    return Platform.isAndroid
        ? 'ca-app-pub-8089412545634153~3097783620'
        : 'ca-app-pub-8089412545634153~7096560778';
  }
}
