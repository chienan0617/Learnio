import 'package:learnio/base.dart';
import 'package:learnio/script/controller/data/data_controller.dart';
import 'package:learnio/script/types/chat_message.dart';
import 'package:learnio/script/types/conversation.dart';
import 'package:learnio/script/types/learning_item.dart';
import 'package:learnio/script/types/project.dart';
import 'package:learnio/script/types/deleted_item.dart';
import 'package:learnio/script/types/trackable.dart';

class Data {
  static final String databaseVersion = System.databaseVersion;
  static final app = Database('app');
  static final recycleBin = Database('recycle-bin');

  static final List<Registerable> _dataList = [
    app,
    recycleBin,
    ...DataController.registrables,
  ];

  static String getDatabaseName(String boxName) {
    return Database.transferKey(
      'QuickLingual@$databaseVersion@${boxName.hashCode}',
    );
  }

  static Future<void> initialize() async {
    registerAdapter();

    for (var data in _dataList) {
      await data.initialize();
    }
  }

  static void registerAdapter() {
    if (!Hive.isAdapterRegistered(200)) {
      Hive.registerAdapter(ColorAdapter());
    }

    // Register generated adapters
    if (!Hive.isAdapterRegistered(48)) {
      Hive.registerAdapter(TrackableDataAdapter());
    }
    if (!Hive.isAdapterRegistered(49)) {
      Hive.registerAdapter(DeletedItemDataAdapter());
    }
    if (!Hive.isAdapterRegistered(50)) {
      Hive.registerAdapter(MessageRoleAdapter());
    }
    if (!Hive.isAdapterRegistered(51)) {
      Hive.registerAdapter(ChatMessageAdapter());
    }
    if (!Hive.isAdapterRegistered(52)) {
      Hive.registerAdapter(ConversationAdapter());
    }
    if (!Hive.isAdapterRegistered(53)) {
      Hive.registerAdapter(LearningItemAdapter());
    }
    if (!Hive.isAdapterRegistered(54)) {
      Hive.registerAdapter(ProjectAdapter());
    }
  }
}

abstract class Registerable {
  Future<void> initialize();
}

class DatabaseGroup {
  late Map<String, Database> _databases;

  DatabaseGroup(Map<String, Database>? database) {
    _databases = database ?? {};
  }

  Database get(String name) {
    if (!_databases.containsKey(name)) {
      throw NameNotFoundError("Can't not find name: $name");
    }

    return _databases[name]!;
  }

  Database newDatabase(String name, Database database) {
    _databases[name] = database;
    return database;
  }

  Map getDatabases() => _databases;
}

class DatabaseExporter {
  /// 匯出所有開啟的 Hive Box 資料為 Map
  static Map<String, dynamic> exportAllData() {
    final Map<String, dynamic> result = {};

    // Hive.boxNames: 取得所有 box 名稱
    for (final boxName in Data._dataList.map(
      (e) => Data.getDatabaseName((e as Database).boxName),
    )) {
      final box = Hive.box(boxName);
      result[boxName] = box.toMap(); // 每個 box 的所有 key-value
    }

    return result;
  }

  /// 匯出為 JSON 字串（可寫入檔案）
  static String exportAllDataToJson() {
    final data = exportAllData();
    return data.toString();
  }
}
