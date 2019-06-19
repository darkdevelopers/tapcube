import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SaveGame {
  String blankContant = '{"Stage": 1, "MonsterLevelInStage": 1, "UserGold": 0.0,"UserDamage": 1.0, "UserLevel": 1, "Hp": 11.0}';
  String path = null;
  String saveGame;
  Future<String> getSaveGame() async {
    path = await getSaveGamePath();
    if(isSaveGameExists()){
      saveGame = readString();
    }

    if(saveGame == null || saveGame.isEmpty){
      createSaveGame();
    }

    saveGame = readString();
    return saveGame;
  }

  void setSaveGame(String content) {
    if(content.isNotEmpty) {
      File(path+"/tapcube.save").writeAsStringSync(content);
    }
  }

  String readString() {
    return File(path+"/tapcube.save").readAsStringSync();
  }

  Future<File> getFile() async {
    return File("${await getSaveGamePath()}/tapcube.save");
  }

  bool isSaveGameExists() {
    return File(path+"/tapcube.save").existsSync();
  }

  void createSaveGame()  {
    File(path+"/tapcube.save").createSync();
    setSaveGame(blankContant);
  }

  Future<String> getSaveGamePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
