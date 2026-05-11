import 'package:learnio/base.dart';

class Tracker implements Initialable {
  static late final List<Database> datas;

  static final List<String> dataBaseName = [
    "989F30E3",
    "75C101CF",
    "C1DB19F8",
    "D3BC5260",
  ];

  @initial
  static Future<void> initialize() async {
    for (final dataName in dataBaseName) {
      datas.add(Database(dataName));
    }
  }
}
