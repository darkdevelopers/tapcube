import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:tap_cube/views/gameview.dart';

class StageDisplay {
  final GameView gv;
  TextPainter painter;
  TextPainter levelPainter;
  TextStyle textStyle;
  Offset targetLocation;
  Offset targetLocationLevel;
  int currentStage = 1;
  int currentLevelInStage = 1;

  StageDisplay(this.gv, int _currentStage, int _currentLevelInStage) {
    currentStage = _currentStage;
    currentLevelInStage = _currentLevelInStage;
    setTargetLocation();
    setTargetLocationLevel();
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    levelPainter = TextPainter(
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
      text: "Stage: ${currentStage}"
    );
    levelPainter.text = TextSpan(
      style: textStyle,
      text: "Monster: ${currentLevelInStage} / 8"
    );
  }

  void setTargetLocation() {
    double left = ((gv.screenSize.width - (gv.tileSize * 6.5)));
    double top = ((gv.screenSize.height - (gv.tileSize * 15.5)));
    targetLocation = Offset(left, top);
  }

  void setTargetLocationLevel() {
    double left = ((gv.screenSize.width - (gv.tileSize * 6.5)));
    double top = ((gv.screenSize.height - (gv.tileSize * 14.9)));
    targetLocationLevel = Offset(left, top);
  }

  void incrementLevel(){
    if(currentLevelInStage == 8){
      currentStage += 1;
      currentLevelInStage = 1;
    }else {
      currentLevelInStage += 1;
    }
  }

  void render(Canvas c) {
    painter.layout();
    painter.paint(c, targetLocation);
    levelPainter.layout();
    levelPainter.paint(c, targetLocationLevel);
  }

  void update(double t) {
    painter.text = TextSpan(
        style: textStyle,
        text: "Stage: ${currentStage}"
    );
    levelPainter.text = TextSpan(
        style: textStyle,
        text: "Monster: ${currentLevelInStage} / 8"
    );
  }
}