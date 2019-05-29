import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

const String testDevice = 'IphoneSimulator';

class Ads {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['idle', 'best games', 'games', 'fun games', 'play free online games', 'play games', 'top games'],
    childDirected: true,
    nonPersonalizedAds: true,
  );

  void init() {
    if (kReleaseMode) {
      FirebaseAdMob.instance.initialize(appId: getAppId());
    } else {
      FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    }
  }

  void loadVideoAds() {
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
    if (kReleaseMode) {
      RewardedVideoAd.instance
          .load(adUnitId: getAppId(), targetingInfo: targetingInfo);
    } else {
      RewardedVideoAd.instance.load(
          adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: targetingInfo);
    }
  }

  String getAppId() {
    return Platform.isAndroid
        ? 'ca-app-pub-8089412545634153/6410165060'
        : 'ca-app-pub-8089412545634153/6410165060';
  }
}
