import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/painting.dart';
import 'package:tap_cube/views/gameview.dart';

class MoneyDisplay {
  final GameView gv;
  Rect moneyRect;
  Sprite moneySprite;
  TextPainter painter;
  TextStyle textStyle;
  double currentMoney = 0;
  Offset targetLocation;

  MoneyDisplay(this.gv, double money) {
    currentMoney = money;
    setTargetLocation();
    moneySprite = Sprite('hud/muenze.png');
    moneyRect = Rect.fromLTWH(((gv.screenSize.width - gv.tileSize) / 3.25), ((gv.screenSize.height - gv.tileSize) / 9.5), 25, 25);
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textStyle = TextStyle(
      color: Color.fromRGBO(255, 255, 255, 0.9),
      fontSize: 20,
      fontWeight: FontWeight.bold,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 7,
          color: Color(0xff000000),
          offset: Offset(3, 3),
        ),
      ],
    );
    painter.text = TextSpan(
        style: textStyle,
        text: currentMoney.toStringAsFixed(2)
    );
  }

  void setTargetLocation() {
    double left = ((gv.screenSize.width - gv.tileSize) / 2.5);
    double top = ((gv.screenSize.height - gv.tileSize) / 9.5);
    targetLocation = Offset(left, top);
  }

  void render(Canvas c) {
    moneySprite.renderRect(c, moneyRect.inflate(2));
    painter.layout();
    painter.paint(c, targetLocation);
  }

  void addMoney(double money){
    currentMoney += money;
  }

  void update(double t) {
    painter.text = TextSpan(
        style: textStyle,
        text: currentMoney.toStringAsFixed(2)
    );
  }
}