import 'package:learnio/base.dart';

class System implements Initialable {
  // static final String version = 'Alpha 0.0.10';
  static final bool debugMode = true;

  static late final bool resetDatabase;
  static late final String version;
  static late final Map latestUpdate;
  static late final String serviceID;
  static late final String packName;
  static late final Map info;
  static late final String databaseVersion;
  static late final String applicationName;
  // static final bool isDarkMode = false;
  // static final String id = Data.app.get<String>('id');
  static final String error = '<Error> !';

  // static Map toMap() => {
  //   'version': version,
  //   'isDarkMode': isDarkMode,
  // };

  @initial
  static Future<void> initialize() async {
    info = await FileHandle.getSystem();

    resetDatabase = info['reset-database'];
    version = info['version'];
    latestUpdate = info['latest-update'];
    serviceID = info['service-id'];
    packName = info['pack-name'];
    databaseVersion = info['database-version'];
    applicationName = info['application-name'];

    // checkInformation(); // TODO: no await
  }

  static Future<void> checkInformation() async {
    try {
      // Data.app.checkKeyExist('id', await Internet.newUser());
    } catch (e) {
      e;
    }
  }
}
