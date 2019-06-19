import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SaveGame {
  String blankContant = '{"Stage": 1, "MonsterLevelInStage": 1, "UserGold": 0.0,"UserDamage": 1.0, "UserLevel": 1, "Hp": 11.0}';
  Future<String> getSaveGame() async {
    if(await isSaveGameExists()){
      return await readString();
    }
    createSaveGame();
    return await readString();
  }

  void setSaveGame(String content) async {
    if(content.isNotEmpty) {
      await File("${await getSaveGamePath()}/tapcube.save").writeAsString(content);
    }
  }

  Future<String> readString() async {
    return await File("${await getSaveGamePath()}/tapcube.save").readAsString();
  }

  Future<File> getFile() async {
    return File("${await getSaveGamePath()}/tapcube.save");
  }

  Future<bool> isSaveGameExists() async {
    return await File("${await getSaveGamePath()}/tapcube.save").exists();
  }

  void createSaveGame() async {
    await File("${await getSaveGamePath()}/tapcube.save").create();
    await setSaveGame(blankContant);
  }

  Future<String> getSaveGamePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
