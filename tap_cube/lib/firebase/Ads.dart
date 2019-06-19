import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

import 'package:tap_cube/components/mob/goldmob.dart';

const String testDevice = 'IphoneSimulator';

class Ads {
  bool videoIsReady = false;

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null
  );

  static const MobileAdTargetingInfo targetingInfoRelease = MobileAdTargetingInfo();

  void init() {
    if(FirebaseAdMob.instance == null) {
      FirebaseAdMob.instance.initialize(appId: getAppId());
    }
  }
  void loadListener(GoldMob goldMob){
    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if(event == RewardedVideoAdEvent.loaded){
        RewardedVideoAd.instance.show();
      }
      if (event == RewardedVideoAdEvent.failedToLoad) {
        goldMob.isVideoAborded = true;
      }
      if (event == RewardedVideoAdEvent.rewarded) {
        goldMob.isRewardedVideo = true;
      }
      if(event == RewardedVideoAdEvent.closed){
        goldMob.isVideoAborded = true;
      }
    };
  }

  void loadVideoAds() {
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
