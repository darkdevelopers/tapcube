import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:tap_cube/views/gameview.dart';
import 'package:tap_cube/firebase/Ads.dart';
import 'package:tap_cube/components/mob/mob.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GoldMob extends Mob {
  int newSpawnTime = 0;
  int minDelay = 1;
  int maxDelay = 2;
  double topValue;
  bool isOffScreen = false;
  bool isTabed = false;
  bool isSpawned = false;
  bool isRewardedVideo = false;
  bool isVideoAborded = false;
  Ads ads;
  Offset targetLocation;
  double get speed => gv.tileSize * 0.5;
  double lootMoney = 0.0;
  BuildContext context;

  GoldMob(GameView gv, double left, double top, double live, double currentLive, int _stage, int _monsterLevel, BuildContext _context) : super (gv, left, top, live, currentLive, _stage, _monsterLevel) {
    topValue = top;
    if(topValue < 75){
      topValue += 75;
    }
    int delay = minDelay + gv.rng.nextInt(maxDelay - minDelay);
    Duration duration = Duration(seconds: delay);
    newSpawnTime = DateTime.now().add(duration).millisecondsSinceEpoch;
    start = left;
    mobSprite = Sprite('mobs/goldmob.png');
    mobRect = Rect.fromLTWH(left, topValue, gv.tileSize, gv.tileSize);
    context = _context;
    ads = new Ads();
    ads.init();
    ads.loadListener(this);
    ads.loadVideoAds();

    setTargetLocation();
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('GOLD CHEST'),
            content: Text('you get gold "${lootMoney.toStringAsFixed(2)}" for watching this Video.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Don\' need \$\$\$'),
                onPressed: () {
                  isVideoAborded = true;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Get \$\$\$'),
                onPressed: () {
                  ads.startVideo();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
        barrierDismissible: false
    );
  }

  void setTargetLocation() {
    double left = start *
        (gv.screenSize.width - (gv.tileSize * 2.025));
    /*double top = gv.rng.nextDouble() *
        (gv.screenSize.height - (gv.tileSize * 1.025));*/
    targetLocation = Offset(left, mobRect.top);
  }

  void calculateLoot(){
    lootMoney = (10 * (stage/10+1) * ((monsterLevel*2)/10+1)) * (7 + gv.rng.nextInt(15 - 7));
  }

  @override
  void render(Canvas c) {
    isSpawned = true;
    mobSprite.renderRect(c, mobRect.inflate(10));
  }

  @override
  void update(double t) {
    if(isSpawned && !isTabed) {
      double stepDistance = speed * t;
      Offset toTarget = targetLocation - Offset(mobRect.left, mobRect.top);
      Offset stepToTarget = Offset.fromDirection(
          toTarget.direction, stepDistance);
      if (mobRect.left < gv.screenSize.width) {
        start += 0.1;
      } else {
        isOffScreen = true;
      }
      mobRect = mobRect.shift(stepToTarget);
      setTargetLocation();
    }else if(isSpawned && isTabed){
      mobRect = mobRect.shift(Offset(400, 400));
      isOffScreen = true;
    }
  }

  void onTapDown(TapDownDetails d) {
    //load dialog
    if(!isTabed) {
      isTabed = true;
      _showDialog();
    }
  }
}