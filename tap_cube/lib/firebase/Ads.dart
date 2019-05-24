import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = 'IphoneSimulator';

class Ads {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );

  void init(){
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
  }

  void loadVideoAds(){
    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}){
      print("RewardedVideoAd event $event");
      if(event == RewardedVideoAdEvent.loaded){
        RewardedVideoAd.instance.show();
      }
      if(event == RewardedVideoAdEvent.failedToLoad){
        print("FAILED TO LOAD");
      }
      if (event == RewardedVideoAdEvent.rewarded) {
        //RewardedVideoAd.instance.load(adUnitId: RewardedVideoAd.testAdUnitId);
        print("RewardedVideoAd Amount $rewardAmount");
      }
    };

    RewardedVideoAd.instance.load(adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: targetingInfo);
  }
}