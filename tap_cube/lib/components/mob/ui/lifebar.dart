import 'dart:ui';
import 'package:tap_cube/views/gameview.dart';
import 'package:flutter/painting.dart';

class LifeBar {
  final GameView gv;
  TextPainter liveTextPaint;
  TextStyle textStyle;
  Rect barRect;
  Paint barPaint;
  Rect liveRect;
  Paint livePaint;
  double left;
  double mobLife = 0.0;
  double currentMobLife = 0.0;
  double lifeWidth = 200;

  LifeBar(this.gv, double life) {
    mobLife = life;
    currentMobLife = life;
    left = ((gv.screenSize.width - gv.tileSize) / 3.35);
    liveTextPaint = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textStyle = TextStyle(
      color: Color.fromRGBO(255, 255, 255, 0.9),
      fontSize: 40,
      fontWeight: FontWeight.bold,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 7,
          color: Color(0xff000000),
          offset: Offset(3, 3),
        ),
      ],
    );
    barPaint = new Paint();
    livePaint = new Paint();
    liveTextPaint.text = new TextSpan(text: "${currentMobLife.toString()} / ${mobLife.toString()} HP");
    barPaint.color = new Color.fromRGBO(180, 180, 180, 1);
    livePaint.color = new Color.fromRGBO(255, 0, 0, 1);
    barRect = new Rect.fromLTWH(((gv.screenSize.width - gv.tileSize) / 3.35),
        ((gv.screenSize.height - gv.tileSize) / 10), 200, 20);
    liveRect = new Rect.fromLTWH(
        left, ((gv.screenSize.height - gv.tileSize) / 10) + 2, lifeWidth, 16);
  }

  Offset getTextLocation() {
    double left = ((gv.screenSize.width - gv.tileSize) / 1.7);
    double top = ((gv.screenSize.height - gv.tileSize) / 10) + 2;
    return  Offset(left, top);
  }

  void render(Canvas c) {
    c.drawRect(barRect, barPaint);
    c.drawRect(liveRect, livePaint);
    liveTextPaint.layout();
    liveTextPaint.paint(c, getTextLocation());
  }

  void update(double t) {}

  void addDamage(int damage) {
    if (lifeWidth != 0) {
      lifeWidth -= damage * mobLife * 2;
      currentMobLife -= damage;
      liveTextPaint.text = new TextSpan(text: "${currentMobLife.toString()} / ${mobLife.toString()} HP");
      liveRect = new Rect.fromLTWH(
          left, ((gv.screenSize.height - gv.tileSize) / 10) + 2, lifeWidth, 16);
    }
    if (lifeWidth <= 0) {
      lifeWidth = 0;
    }
  }
}