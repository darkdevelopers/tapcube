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

  LifeBar(this.gv, double life, double currentLife) {
    mobLife = life;
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
    liveTextPaint.text = new TextSpan(
        text: "${currentMobLife.toStringAsFixed(1)} / ${mobLife.toStringAsFixed(1)} HP");
    barPaint.color = new Color.fromRGBO(180, 180, 180, 1);
    livePaint.color = new Color.fromRGBO(255, 0, 0, 1);
    barRect = new Rect.fromLTWH(((gv.screenSize.width - gv.tileSize) / 3.35),
        ((gv.screenSize.height - gv.tileSize) / 7), 200, 20);
    liveRect = new Rect.fromLTWH(
        left, ((gv.screenSize.height - gv.tileSize) / 7) + 2, lifeWidth, 16);

    if(currentLife <= 0.0){
      currentMobLife = life;
    }else {
      currentMobLife = currentLife;
      lifeWidth -= (mobLife - currentLife) / mobLife * 200;
      liveTextPaint.text = new TextSpan(
          text: "${currentMobLife.toStringAsFixed(1)} / ${mobLife.toStringAsFixed(1)} HP");
      liveRect = new Rect.fromLTWH(
          left, ((gv.screenSize.height - gv.tileSize) / 7) + 2, lifeWidth, 16);
    }
  }

  Offset getTextLocation() {
    double left = ((gv.screenSize.width - gv.tileSize) / 1.75);
    double top = ((gv.screenSize.height - gv.tileSize) / 7) + 2;
    return Offset(left, top);
  }

  void render(Canvas c) {
    c.drawRect(barRect, barPaint);
    c.drawRect(liveRect, livePaint);
    liveTextPaint.layout();
    liveTextPaint.paint(c, getTextLocation());
  }

  void update(double t) {}

  void addDamage(double damage) {
    if (currentMobLife > 0.0) {
      lifeWidth -= damage / mobLife * 200;
      currentMobLife -= damage;
      liveTextPaint.text = new TextSpan(
          text: "${currentMobLife.toStringAsFixed(1)} / ${mobLife.toStringAsFixed(1)} HP");
      liveRect = new Rect.fromLTWH(
          left, ((gv.screenSize.height - gv.tileSize) / 7) + 2, lifeWidth, 16);
    }
    if (currentMobLife <= 0.0) {
      lifeWidth = 0;
      liveRect = new Rect.fromLTWH(
          left, ((gv.screenSize.height - gv.tileSize) / 7) + 2, lifeWidth, 16);
      liveTextPaint.text = new TextSpan(
          text: "0.0 / ${mobLife.toStringAsFixed(1)} HP");
    }
  }
}