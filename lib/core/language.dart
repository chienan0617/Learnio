import 'package:learnio/base.dart';

class Language implements Initialable {
  static Map words = {};
  static List<String> langList = ['en', 'zh'];
  static int langIndex = Data.app.get<int>('language');
  static String langName = langList[langIndex];

  static bool initialized = false;

  static Future<void> initialize() async {
    words[langName] = await FileHandle.getLanguageWord(langName);
    initialized = true;
  }

  static String word(String text) {
    // if (!initialized)
    return words[langName][text] ?? System.error;
  }

  static Future<void> onChangeIndex(int newIndex) async {
    langIndex = newIndex;
    Data.app.put<int>('language', newIndex);

    await initialize();
  }
}

String word(String text) => Language.word(text);
