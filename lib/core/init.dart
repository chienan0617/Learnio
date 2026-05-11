import 'package:learnio/base.dart';

class Initialize {
  @initial
  static Future<void> setupApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    // await Constant.initialize();
    await Hive.initFlutter();
    await System.initialize();
    await Data.initialize();
    await AppTheme.initialize();
    // await Native.initialize();
    // await Tracker.initialize();
    // await FlutterNativeTimezone.initialize();
    // await Internet.initialize();
    // await Language.initialize();
    // await Notify.initialize();
    // await Tutorial.initialize();
    // await PriorityIO.initialize();
    // await CommonColors.initialize();
    // await Calendar.initialize();
    // compute(callback, message)
    if (true) await test();
  }

  @temporary
  @Test()
  static Future<void> test() async {}
}
