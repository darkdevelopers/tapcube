import 'dart:ui';
import 'package:tap_cube/game/gameview.dart';

class LifeBar {
  final GameView gv;
  Rect barRect;
  Paint barPaint;
  Rect holderRect;
  Paint holderPaint;

  LifeBar(this.gv) {
    barPaint = Paint();
    holderPaint = Paint();
    holderPaint.color = Color(0x88ffffff);
  }

  void render(Canvas c) {
    if (barRect == null) return;
    c.drawRect(holderRect, holderPaint);
    c.drawRect(barRect, barPaint);
  }
  void update(double t) {
    holderRect ??= Rect.fromLTWH(0, -(gv.screenSize.height - 2.1875), 9, .25);
    barRect = Rect.fromLTWH(
      0,
      -(gv.screenSize.height - 2.1875),
      9 * 0.0,
      .25,
    );
    barPaint.color = Color.fromRGBO(
      255,
      0,
      0,
      (0 * .5) + .4,
    );
  }
}