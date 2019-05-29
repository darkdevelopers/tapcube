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
  Sprite userDamageSprite;
  Rect moneyRect;
  Sprite moneySprite;
  TextPainter painter;
  TextStyle textStyle;
  Offset targetLocation;
  int currentDamage;
  int nextDamageUpdate;
  int userLevel;

  User(this.gv, double left, double top, int damage, int _userLevel) {
    barPaint = new Paint();
    barPaint.color = new Color.fromRGBO(35, 35, 35, 0.6);
    barRect = new Rect.fromLTWH(0,
        ((gv.screenSize.height - gv.tileSize)/1.1), gv.screenSize.width, 150);

    userSprite = Sprite('user/user.png');
    userRect = Rect.fromLTWH(left, top, gv.tileSize, gv.tileSize);

    userDamageSprite = Sprite('hud/interaction.png');
    userDamageRect = Rect.fromLTWH((gv.screenSize.width - gv.tileSize) / 1.3,
        (gv.screenSize.height - gv.tileSize) / 1.06, gv.tileSize * 2.5,
        gv.tileSize * 1.25);

    moneySprite = Sprite('hud/muenze.png');
    moneyRect = Rect.fromLTWH(((gv.screenSize.width - gv.tileSize) / 1.27),
        ((gv.screenSize.height - gv.tileSize) / 1.055), 20, 20);

    currentDamage = damage;
    userLevel = _userLevel;

    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
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
    painter.text = TextSpan(
        style: textStyle,
        text: 0.toString()
    );
    setTargetLocation();
  }

  void setTargetLocation() {
    double left = ((gv.screenSize.width - gv.tileSize) / 1.155);
    double top = ((gv.screenSize.height - gv.tileSize) / 1.057);
    targetLocation = Offset(left, top);
  }

  void render(Canvas c) {
    c.drawRect(barRect, barPaint);
    userSprite.renderRect(c, userRect.inflate(2));
    userDamageSprite.renderRect(c, userDamageRect);
    moneySprite.renderRect(c, moneyRect);
    painter.layout();
    painter.paint(c, targetLocation);
  }

  void update(double t) {}
}