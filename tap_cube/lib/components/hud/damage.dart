import 'dart:ui';
import 'dart:async';
import 'package:flutter/painting.dart';
import 'package:tap_cube/views/gameview.dart';

class DamageDisplay {
  final GameView gv;
  TextPainter painter;
  TextStyle textStyle;
  Offset position;
  int damage;
  bool isOffScreen = false;
  Offset targetLocation;

  double get speed => gv.tileSize * 1.5;

  DamageDisplay(this.gv, int _damage) {
    damage = _damage;
    setTargetLocation();
    /*painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textStyle = TextStyle(
      color: Color(0xffffffff),
      fontSize: 30,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 7,
          color: Color(0xff000000),
          offset: Offset(3, 3),
        ),
      ],
    );

    position = Offset.zero;

    painter.text = TextSpan(
      text: '',
      style: textStyle,
    );*/
  }

  void setTargetLocation() {
    double left = gv.tileSize;
    double top = gv.rng.nextDouble() *
        (gv.screenSize.height - (gv.tileSize * 1.025));
    targetLocation = Offset(left, top);
  }

  void render(Canvas c) {
    /*painter.layout();
    painter.paint(c, position);*/
  }

  void update(double t) {
    double stepDistance = speed * t;
    Offset toTarget = targetLocation - Offset(gv.tileSize, 0);
    Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
    /*painter.text = TextSpan(
      text: damage.toString(),
      style: textStyle,
    );

    painter.layout();

    position = Offset(
      (gv.screenSize.width / 2) - (painter.width / 2),
      (gv.screenSize.height * .25) - (painter.height / 2),
    );*/
  }
}