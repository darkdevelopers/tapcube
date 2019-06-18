import 'dart:math';
import 'dart:ui';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tap_cube/components/background.dart';
import 'package:tap_cube/components/user.dart';
import 'package:tap_cube/components/mob/mob.dart';
import 'package:tap_cube/components/mob/boss.dart';
import 'package:tap_cube/components/mob/goldmob.dart';
import 'package:tap_cube/components/hud/damage.dart';
import 'package:tap_cube/components/hud/stage.dart';
import 'package:tap_cube/components/hud/money.dart';
import 'package:tap_cube/components/hud/option.dart';
import 'package:tap_cube/savegame.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:tap_cube/state/optionstates.dart';

class GameView extends Game {
  final optionStates _optionStates = optionStates.getInstance();

  int currentUserDamage = 0;
  double tileSize;

  List<DamageDisplay> damageDisplays;
  StageDisplay stageDisplay;
  MoneyDisplay moneyDisplay;
  OptionDisplay optionDisplay;

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
  BuildContext context;

  SaveGame saveGame;
  Map<String, dynamic> saveGameDataArray;

  TapGestureRecognizer tapperGameView;

  GameView(SaveGame _saveGame, Map<String, dynamic> _saveGameDataArray,
      BuildContext _context) {
    saveGame = _saveGame;
    saveGameDataArray = _saveGameDataArray;
    context = _context;
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    background = Background(this);
    goldMobs = List<GoldMob>();
    damageDisplays = List<DamageDisplay>();
    stageDisplay = StageDisplay(this, saveGameDataArray['Stage'],
        saveGameDataArray['MonsterLevelInStage']);
    moneyDisplay = MoneyDisplay(this, saveGameDataArray['UserGold']);
    optionDisplay = OptionDisplay(this, context);
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

    stageDisplay.render(canvas);
    moneyDisplay.render(canvas);
    optionDisplay.render(canvas);

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
  }

  void update(double t) {
    goldMobs.removeWhere((GoldMob goldMob) =>
    goldMob.isOffScreen && goldMob.isSpawned && (goldMob.isRewardedVideo || goldMob.isVideoAborded));
    goldMobs.forEach((GoldMob goldMob) {
      goldMob.update(t);
      if(goldMob.isRewardedVideo) {
        moneyDisplay.addMoney(goldMob.lootMoney);
        goldMob.isRewardedVideo=false;
      }
    });
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
    if(!_optionStates.isOptionDialogOpen){
      optionDisplay.isOpen = false;
    }
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
      updateHpSaveGame();
      if (mob.isDead && mob.isOffScreen) {
        moneyDisplay.addMoney(mob.lootMoney);
        moneyDisplay.update(t);
        stageDisplay.incrementLevel();
        stageDisplay.update(t);
        updateSaveGame();
        mob = null;
      }
    } else if (stageDisplay.currentLevelInStage == 8 && boss != null) {
      boss.update(t);
      updateHpSaveGame();
      if (boss.isDead && boss.isOffScreen) {
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
    saveGameDataArray['UserDamage'] = user.currentDamage;
    saveGameDataArray['UserLevel'] = user.userLevel;
    saveGame.setSaveGame(jsonEncode(saveGameDataArray));
  }

  void updateHpSaveGame(){
    if(mob != null) {
      saveGameDataArray['Hp'] = mob.mobBar.currentMobLife;
    }else if(boss != null){
      saveGameDataArray['Hp'] = boss.mobBar.currentMobLife;
    }
    saveGame.setSaveGame(jsonEncode(saveGameDataArray));
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void spawnUser() {
    user = User(this, ((screenSize.width - tileSize) / 2),
        ((screenSize.height - tileSize) / 1.5), saveGameDataArray['UserDamage'],
        saveGameDataArray['UserLevel']);
  }

  void spawnMob() {
    double life = 0.0;
    double currentLife = saveGameDataArray['Hp'];
    if ((stageDisplay.currentStage == 1 &&
        stageDisplay.currentLevelInStage == 1) ||
        (stageDisplay.currentStage == 1 &&
            stageDisplay.currentLevelInStage == 2)) {
      life = 10 * ((stageDisplay.currentLevelInStage / 10) + 1);
    } else {
      life = (((stageDisplay.currentStage *
          (stageDisplay.currentLevelInStage / 10 + stageDisplay.currentStage)) +
          (stageDisplay.currentLevelInStage / 10 + 1) * (user.userLevel)) * 2 *
          10 * 1) * 4;
    }
    if(currentLife <= 0.0){
      currentLife = life;
    }

    mob = Mob(this, ((screenSize.width - tileSize * 3) / 4),
        ((screenSize.height - tileSize) / 2.1),
        life,
        currentLife,
        stageDisplay.currentStage, stageDisplay.currentLevelInStage);
  }

  void spawnBoss() {
    double life = 0.0;
    double currentLife = saveGameDataArray['Hp'];

    life = (((stageDisplay.currentStage * (stageDisplay.currentLevelInStage / 5 +
        stageDisplay.currentStage)) +
        (stageDisplay.currentLevelInStage / 10 + 1) *
            (user.userLevel / 2)) * 2 * 10 * 1) * 5;

    if(currentLife <= 0.0){
      currentLife = life;
    }

    boss = Boss(this, ((screenSize.width - tileSize * 3) / 4),
        ((screenSize.height - tileSize) / 2.1),
        life,
        currentLife,
        stageDisplay.currentStage, stageDisplay.currentLevelInStage);
  }

  void spawnGoldMob() {
    double top = rng.nextDouble() * (screenSize.height - tileSize);
    goldMobs.add(GoldMob(this, 0.0, top, 0, 0.0, stageDisplay.currentStage,
        stageDisplay.currentLevelInStage, context));
  }

  void addDamage() {
    if (mob != null) {
      if (!mob.isDead) {
        mob.isHited = true;
        damageDisplays.add(DamageDisplay(this, user.currentDamage));
        mob.mobBar.addDamage(user.currentDamage);
      }
    } else if (boss != null) {
      if (!boss.isDead) {
        boss.isHited = true;
        damageDisplays.add(DamageDisplay(this, user.currentDamage));
        boss.mobBar.addDamage(user.currentDamage);
      }
    }
  }

  void onTapDown(TapDownDetails d) {
    if(!optionDisplay.isOpen) {
      if (goldMobs.isNotEmpty) {
        goldMobs.forEach((GoldMob goldMob) {
          if (goldMob.mobRect.contains(d.globalPosition) && !goldMob.isOffScreen) {
            goldMob.onTapDown(d);
          } else {
            if (optionDisplay.optionRect.contains(d.globalPosition)) {
              optionDisplay.onTapDown();
              _optionStates.isOptionDialogOpen = true;
            } else {
              if (user.userDamageRect.contains(d.globalPosition) &&
                  user.isUpgradeAvailable) {
                user.upgradeUser();
                updateSaveGame();
              } else {
                addDamage();
              }
            }
          }
        });
      } else {
        if (optionDisplay.optionRect.contains(d.globalPosition)) {
          optionDisplay.onTapDown();
        } else {
          if (user.userDamageRect.contains(d.globalPosition) &&
              user.isUpgradeAvailable) {
            user.upgradeUser();
            updateSaveGame();
          } else {
            addDamage();
          }
        }
      }
    }
  }

  void reloadGesture(){
    if(tapperGameView != null){
      tapperGameView.onTapDown = onTapDown;
    }
  }

  TapGestureRecognizer addGesture(){
    tapperGameView = TapGestureRecognizer();
    tapperGameView.onTapDown = onTapDown;
    return tapperGameView;
  }
}
