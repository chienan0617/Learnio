
import 'package:learnio/base.dart';

class FileHandle {
  static Map data = {};

  static dynamic getAndSaveCache(String key, String fileName) async {
    if (data[key] == null) {

      var decoded = await json.decode(
        await rootBundle.loadString('assets/config/$fileName.json'),
      );

      data[key] = decoded;
      // return decoded;
    }
    return data[key];
  }

  @method
  static Future<Map<String, dynamic>>? getRegister(String name) async {
    return (await getAndSaveCache('register', 'register') as Map)[name] ?? {};
  }

  @method
  static Future<Map> getLanguageWord(String lang) async {
    return (await getAndSaveCache('language', 'language/$lang') as Map);
  }

  @method
  static Future<Map<String, dynamic>> getTutorialKeys() async {
    return (await getAndSaveCache('tutorial', 'tutorial/tutorial'));
  }

  @method
  static Future<Map> getTutorialKeysLang(String lang) async {
    return (await getAndSaveCache('tutorialLang', 'tutorial/$lang'));
  }

  @method
  static Future<List> getColors(String lang) async {
    return (await getAndSaveCache('color', 'color'))[lang];
  }

  @method
  static Future<Map> getSystem() async {
    return (await getAndSaveCache('system', 'system'));
  }

  @Deprecated("use getAndSaveCache() instead.")
  static Future<dynamic> get(String key) async {}
}
