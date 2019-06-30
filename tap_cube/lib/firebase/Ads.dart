import 'package:firebase_admob/firebase_admob.dart';
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
    FirebaseAdMob.instance.initialize(appId: getAppId());
  }
  void loadListener(GoldMob goldMob){
    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if(event == RewardedVideoAdEvent.loaded){
        videoIsReady = true;
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

  void startVideo(){
    if(videoIsReady){
      RewardedVideoAd.instance.show();
    }
  }

  void loadVideoAds() {
    RewardedVideoAd.instance.load(adUnitId: getAdUnitId(), targetingInfo: targetingInfoRelease);
  }

  String getAdUnitId() {
    return Platform.isAndroid
        ? 'ca-app-pub-8089412545634153/5869006911'
        : 'ca-app-pub-8089412545634153/5863370155';
  }

  String getAppId() {
    return Platform.isAndroid
        ? 'ca-app-pub-8089412545634153~3097783620'
        : 'ca-app-pub-8089412545634153~7096560778';
  }
}
