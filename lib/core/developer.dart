import 'package:learnio/base.dart';

class Developer {
  static bool isDeveloperMode() => Data.app.get<bool>("developer", false);
}

bool isDeveloperMode() => Developer.isDeveloperMode();
