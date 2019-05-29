import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SaveGame {
  String blankContant = '{"Stage": 1, "MonsterLevelInStage": 1, "UserGold": 0.0,"UserDamage": 1.0, "UserLevel": 1}';
  Future<String> getSaveGame() async {
    if(await isSaveGameExists()){
      return await readString();
    }
    await createSaveGame();
    return await readString();
  }

  void setSaveGame(String content) async {
    File("${await getSaveGamePath()}/tapcube.save").writeAsString(content);
  }

  Future<String> readString() async {
    return File("${await getSaveGamePath()}/tapcube.save").readAsString();
  }

  Future<File> getFile() async {
    return File("${await getSaveGamePath()}/tapcube.save");
  }

  Future<bool> isSaveGameExists() async {
    return File("${await getSaveGamePath()}/tapcube.save").existsSync();
  }

  void createSaveGame() async {
    File("${await getSaveGamePath()}/tapcube.save").createSync();
    setSaveGame(blankContant);
  }

  Future<String> getSaveGamePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
