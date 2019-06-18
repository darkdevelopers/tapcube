import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/painting.dart';
import 'package:tap_cube/views/gameview.dart';

class User {
  final GameView gv;
  Rect barRect;
  Paint barPaint;
  Rect userRect;
  Sprite userSprite;
  Rect userDamageRect;
  Rect userDamageRectDisabled;
  Sprite userDamageSprite;
  Sprite userDamageSpriteDisabled;
  Rect moneyRect;
  Sprite moneySprite;
  TextPainter painter;
  TextPainter dmgPainter;
  TextPainter userInformationPrinter;
  TextPainter userTapDmgPrinter;
  TextPainter userLevelPainter;
  TextStyle textStyle;
  TextStyle textStyleDmg;
  Offset targetLocation;
  Offset dmgTargetLocation;
  Offset userInformationTargetLocation;
  Offset userTapDmgTargetLocation;
  Offset userLevelTargetLocation;
  double currentDamage;
  double nextDamageUpdate;
  double nextUserLevelPrice;
  int userLevel;
  bool isUpgradeAvailable = false;

  User(this.gv, double left, double top, double damage, int _userLevel) {
    currentDamage = damage;
    userLevel = _userLevel;

    userSprite = Sprite('user/user.png');
    userRect = Rect.fromLTWH(left, top, gv.tileSize, gv.tileSize);

    setUserInformationSystem();
  }

  void calculatePriceAndDamage(){
    nextDamageUpdate = (5 + (userLevel / 10 + 1) * 1.05) + (((userLevel + 1.05) / 10) + 1.05);
    nextUserLevelPrice = (13 * 1.25 * (userLevel / 10 + 1)) * (1.5 * userLevel);
  }

  void printText(){
    painter.text = TextSpan(
        style: textStyle,
        text: nextUserLevelPrice.toStringAsFixed(2)
    );

    dmgPainter.text = TextSpan(
        style: textStyleDmg,
        text: "+ ${nextDamageUpdate.toStringAsFixed(2)} DMG"
    );

    userInformationPrinter.text = TextSpan(
        style: textStyle,
        text: "Player Informations"
    );

    userTapDmgPrinter.text = TextSpan(
        style: textStyle,
        text: "Tapdamage: ${currentDamage.toStringAsFixed(2)} DMG"
    );

    userLevelPainter.text = TextSpan(
        style: textStyle,
        text: "Level: ${userLevel.toString()}"
    );
  }

  void setUserInformationSystem() {
    barPaint = new Paint();
    barPaint.color = new Color.fromRGBO(35, 35, 35, 0.6);
    barRect = new Rect.fromLTWH(0,
        ((gv.screenSize.height - gv.tileSize) / 1.1), gv.screenSize.width, 150);

    userDamageSprite = Sprite('hud/interaction.png');
    userDamageRect = Rect.fromLTWH((gv.screenSize.width - gv.tileSize) / 1.3,
        (gv.screenSize.height - gv.tileSize) / 1.06, gv.tileSize * 2.5,
        gv.tileSize * 1.25);

    userDamageSpriteDisabled = Sprite('hud/interaction_disabled.png');
    userDamageRectDisabled = Rect.fromLTWH((gv.screenSize.width - gv.tileSize) / 1.3,
        (gv.screenSize.height - gv.tileSize) / 1.06, gv.tileSize * 2.5,
        gv.tileSize * 1.25);

    moneySprite = Sprite('hud/muenze.png');
    moneyRect = Rect.fromLTWH(((gv.screenSize.width - gv.tileSize) / 1.27),
        ((gv.screenSize.height - gv.tileSize) / 1.055), 20, 20);

    calculatePriceAndDamage();

    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    dmgPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    userInformationPrinter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    userTapDmgPrinter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    userLevelPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyleDmg = TextStyle(
      color: Color.fromRGBO(255, 255, 255, 0.9),
      fontSize: 15,
      fontWeight: FontWeight.bold,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 1,
          color: Color(0xff000000),
          offset: Offset(2, 2),
        ),
      ],
    );

    textStyle = TextStyle(
      color: Color.fromRGBO(255, 255, 255, 0.9),
      fontSize: 18,
      fontWeight: FontWeight.bold,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 1,
          color: Color(0xff000000),
          offset: Offset(2, 2),
        ),
      ],
    );

    printText();

    setTargetLocation();
    setDmgTargetLocation();
    setUserInformationTargetLocation();
    setUserLevelTargetLocation();
    setUserTapDmgTargetLocation();
    checkUpgradeAvailable();
  }

  void setTargetLocation() {
    double left = ((gv.screenSize.width - gv.tileSize) / 1.15);
    double top = ((gv.screenSize.height - gv.tileSize) / 1.057);
    targetLocation = Offset(left, top);
  }

  void setDmgTargetLocation() {
    double left = ((gv.screenSize.width - gv.tileSize) / 1.285);
    double top = ((gv.screenSize.height - gv.tileSize) / 1.02);
    dmgTargetLocation = Offset(left, top);
  }

  void setUserInformationTargetLocation() {
    double left = ((gv.screenSize.width - gv.tileSize) / 17);
    double top = ((gv.screenSize.height - gv.tileSize) / 1.07);
    userInformationTargetLocation = Offset(left, top);
  }

  void setUserTapDmgTargetLocation() {
    double left = ((gv.screenSize.width - gv.tileSize) / 17);
    double top = ((gv.screenSize.height - gv.tileSize) / 1.04);
    userTapDmgTargetLocation = Offset(left, top);
  }

  void setUserLevelTargetLocation() {
    double left = ((gv.screenSize.width - gv.tileSize) / 17);
    double top = ((gv.screenSize.height - gv.tileSize) / 1.01);
    userLevelTargetLocation = Offset(left, top);
  }

  void checkUpgradeAvailable() {
    if (gv.moneyDisplay.currentMoney >= nextUserLevelPrice) {
      isUpgradeAvailable = true;
    } else {
      isUpgradeAvailable = false;
    }
  }

  void upgradeUser(){
    if(isUpgradeAvailable){
      gv.moneyDisplay.removeMoney(nextUserLevelPrice);
      currentDamage += nextDamageUpdate;
      userLevel += 1;
    }
  }

  void render(Canvas c) {
    userSprite.renderRect(c, userRect.inflate(2));
    c.drawRect(barRect, barPaint);
    if (isUpgradeAvailable) {
      userDamageSprite.renderRect(c, userDamageRect);
      moneySprite.renderRect(c, moneyRect);
      painter.layout();
      painter.paint(c, targetLocation);
      dmgPainter.layout();
      dmgPainter.paint(c, dmgTargetLocation);
    }else{
      userDamageSpriteDisabled.renderRect(c, userDamageRectDisabled);
      moneySprite.renderRect(c, moneyRect);
      painter.layout();
      painter.paint(c, targetLocation);
      dmgPainter.layout();
      dmgPainter.paint(c, dmgTargetLocation);
    }
    userInformationPrinter.layout();
    userInformationPrinter.paint(c, userInformationTargetLocation);
    
    userTapDmgPrinter.layout();
    userTapDmgPrinter.paint(c, userTapDmgTargetLocation);
    
    userLevelPainter.layout();
    userLevelPainter.paint(c, userLevelTargetLocation);
  }

  void update(double t) {
    checkUpgradeAvailable();
    calculatePriceAndDamage();
    printText();
    gv.moneyDisplay.update(t);
  }
}