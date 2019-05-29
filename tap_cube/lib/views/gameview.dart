import 'dart:math';
import 'dart:ui';
import 'dart:convert';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:tap_cube/components/background.dart';
import 'package:tap_cube/components/user.dart';
import 'package:tap_cube/components/mob/mob.dart';
import 'package:tap_cube/components/mob/boss.dart';
import 'package:tap_cube/components/mob/goldmob.dart';
import 'package:tap_cube/components/hud/damage.dart';
import 'package:tap_cube/components/hud/stage.dart';
import 'package:tap_cube/components/hud/money.dart';
import 'package:tap_cube/savegame.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class GameView extends Game {
  int currentUserDamage = 0;
  double tileSize;

  List<DamageDisplay> damageDisplays;
  StageDisplay stageDisplay;
  MoneyDisplay moneyDisplay;

  Size screenSize;
  Background background;
  User user;
  Mob mob;
  Boss boss;
  List<GoldMob> goldMobs;
  FirebaseAnalytics analytics;
  FirebaseAnalyticsObserver observer;
  Random rng;
  int spawnGoldMobDelay;

  SaveGame saveGame;
  Map<String, dynamic> saveGameDataArray;

  GameView(SaveGame _saveGame, Map<String, dynamic> _saveGameDataArray) {
    saveGame = _saveGame;
    saveGameDataArray = _saveGameDataArray;
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    background = Background(this);
    goldMobs = List<GoldMob>();
    damageDisplays = List<DamageDisplay>();
    stageDisplay = StageDisplay(this, saveGameDataArray['Stage'], saveGameDataArray['MonsterLevelInStage']);
    moneyDisplay = MoneyDisplay(this, saveGameDataArray['UserGold']);
    rng = Random();
    spawnGoldMobDelay = rng.nextInt(600);
    spawnUser();

    analytics = new FirebaseAnalytics();
    observer = new FirebaseAnalyticsObserver(analytics: analytics);

    analytics.logAppOpen();
  }

  void render(Canvas canvas) {
    background.render(canvas);
    if (mob != null) {
      mob.render(canvas);
    }
    if (boss != null) {
      boss.render(canvas);
    }
    user.render(canvas);
    goldMobs.forEach((GoldMob goldMob) {
      if (goldMob.newSpawnTime <= DateTime
          .now()
          .millisecondsSinceEpoch) {
        goldMob.render(canvas);
      }
    });
    damageDisplays.forEach((DamageDisplay damageDisplay) {
      damageDisplay.render(canvas);
    });
    stageDisplay.render(canvas);
    moneyDisplay.render(canvas);
  }

  void update(double t) {
    goldMobs.forEach((GoldMob goldMob) => goldMob.update(t));
    goldMobs.removeWhere((GoldMob goldMob) => goldMob.isOffScreen);
    if (goldMobs.isEmpty) {
      spawnGoldMob();
    }
    damageDisplays.forEach((DamageDisplay damageDisplay) =>
        damageDisplay.update(t));
    damageDisplays.removeWhere((DamageDisplay damageDisplay) =>
    damageDisplay.isOffScreen);
    spawnMonster();
    updateMonster(t);
    user.update(t);
  }

  void spawnMonster() {
    if (stageDisplay.currentLevelInStage < 8 && mob == null) {
      spawnMob();
    } else if (stageDisplay.currentLevelInStage == 8 && boss == null) {
      spawnBoss();
    }
  }

  void updateMonster(double t) {
    if (stageDisplay.currentLevelInStage < 8 && mob != null) {
      mob.update(t);
      if (mob.isDead) {
        moneyDisplay.addMoney(mob.lootMoney);
        moneyDisplay.update(t);
        stageDisplay.incrementLevel();
        stageDisplay.update(t);
        updateSaveGame();
        mob = null;
      }
    } else if (stageDisplay.currentLevelInStage == 8 && boss != null) {
      boss.update(t);
      if (boss.isDead) {
        moneyDisplay.addMoney(boss.lootMoney);
        moneyDisplay.update(t);
        stageDisplay.incrementLevel();
        stageDisplay.update(t);
        updateSaveGame();
        boss = null;
      }
    }
  }

  void updateSaveGame() {
    saveGameDataArray['Stage'] = stageDisplay.currentStage;
    saveGameDataArray['MonsterLevelInStage'] = stageDisplay.currentLevelInStage;
    saveGameDataArray['UserGold'] = moneyDisplay.currentMoney;
    saveGame.setSaveGame(jsonEncode(saveGameDataArray));
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void spawnUser() {
    user = User(this, ((screenSize.width - tileSize) / 2),
        ((screenSize.height - tileSize) / 1.5), saveGameDataArray['UserDamage'], saveGameDataArray['UserLevel']);
  }

  void spawnMob() {
    mob = Mob(this, ((screenSize.width - tileSize * 3) / 4),
        ((screenSize.height - tileSize) / 2.1),
        (((stageDisplay.currentStage * 1.5) +
            (stageDisplay.currentLevelInStage / 10 + 1)) * 2 * 10 * 1),
        stageDisplay.currentStage, stageDisplay.currentLevelInStage);
  }

  void spawnBoss() {
    boss = Boss(this, ((screenSize.width - tileSize * 3) / 4),
        ((screenSize.height - tileSize) / 2.1),
        (((stageDisplay.currentStage * 1.5) +
            (stageDisplay.currentLevelInStage / 10 + 1)) * 5 * 10 * 2.5),
        stageDisplay.currentStage, stageDisplay.currentLevelInStage);
  }

  void spawnGoldMob() {
    double top = rng.nextDouble() * (screenSize.height - tileSize);
    goldMobs.add(GoldMob(this, 0.0, top, 0, stageDisplay.currentStage,
        stageDisplay.currentLevelInStage));
  }

  void addDamage() {
    if (mob != null) {
      if (!mob.isDead) {
        damageDisplays.add(DamageDisplay(this, user.currentDamage));
        mob.mobBar.addDamage(user.currentDamage);
      }
    } else if (boss != null) {
      if (!boss.isDead) {
        damageDisplays.add(DamageDisplay(this, user.currentDamage));
        boss.mobBar.addDamage(user.currentDamage);
      }
    }
  }

  void onTapDown(TapDownDetails d) {
    if (goldMobs.isNotEmpty) {
      goldMobs.forEach((GoldMob goldMob) {
        if (goldMob.mobRect.contains(d.globalPosition)) {
          goldMob.onTapDown(d);
        } else {
          addDamage();
        }
      });
    } else {
      addDamage();
    }

    /*analytics.logEvent(name: 'levelup', parameters: <String, dynamic>{
      'int': 1,
    }
    );
    */
  }
}
