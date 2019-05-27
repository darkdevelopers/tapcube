import 'dart:ui';
import 'dart:async';
import 'package:flutter/painting.dart';
import 'package:tap_cube/views/gameview.dart';

class DamageDisplay {
  final GameView gv;
  TextPainter painter;
  TextStyle textStyle;
  int damage;
  bool isOffScreen = false;
  Offset targetLocation;
  double start = 100;

  double get speed => gv.tileSize * 1.5;

  DamageDisplay(this.gv, int _damage) {
    damage = _damage;
    setTargetLocation();

    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textStyle = TextStyle(
      color: Color.fromRGBO(233, 22, 15, 0.9),
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
  }

  void setTargetLocation() {
    double left = ((gv.screenSize.width - gv.tileSize) / 2);
    double top =  ((gv.screenSize.height - gv.tileSize) / 2) - start;
    targetLocation = Offset(left, top);
  }

  void render(Canvas c) {
    painter.layout();
    painter.paint(c, targetLocation);
  }

  void update(double t) {
    if(start <= 150) {
      start += 1;
    }else{
      isOffScreen = true;
    }

    painter.text = TextSpan(
      text: damage.toString(),
      style: textStyle,
    );

    setTargetLocation();
  }
}