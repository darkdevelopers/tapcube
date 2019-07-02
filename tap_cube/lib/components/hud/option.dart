import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flame/sprite.dart';
import 'package:tap_cube/views/gameview.dart';
import 'package:tap_cube/translation.dart';
import 'package:url_launcher/url_launcher.dart';

class OptionDisplay {
  final GameView gv;
  Rect optionRect;
  Sprite optionSprite;
  BuildContext context;
  bool isOpen = false;

  OptionDisplay(this.gv, BuildContext _context) {
    optionSprite = Sprite('hud/option.png');
    optionRect = Rect.fromLTWH(0, 10, 100, 100);
    context = _context;
  }

  void render(Canvas c) {
    optionSprite.renderRect(c, optionRect.inflate(2));
  }

  void update(double t) {}

  void onTapDown(){
    _showDialog();

    isOpen = true;
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {},
            child: AlertDialog(
              title: Text(Translations.of(context).text('option_general_informations')),
              content: Container(
                width: gv.screenSize.width,
                height: gv.screenSize.height,
                child: SingleChildScrollView(
                  child: ListBody(children: <Widget>[
                    ListTile(
                      title: Text(Translations.of(context).text('option_impressum')),
                      onTap: (){
                        _launchImpressumURL();
                      },
                      trailing: Icon(Icons.arrow_right),
                    ),
                    ListTile(
                      title: Text(Translations.of(context).text('option_privacy_policy')),
                      onTap: (){
                        _launchDatenschutzURL();
                      },
                      trailing: Icon(Icons.arrow_right),
                    ),
                  ]),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(Translations.of(context).text('option_close')),
                  onPressed: () {
                    isOpen = false;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
        barrierDismissible: false
    );
  }

  _launchImpressumURL() async {
    const url = 'https://tapcube.darkdevelopers.de/impressum.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchDatenschutzURL() async {
    const url = 'https://tapcube.darkdevelopers.de/datenschutzerklaerung.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}