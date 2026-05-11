import 'package:learnio/base.dart';

class AppTheme {
  static late Map<String, dynamic> data;

  static Future<void> initialize() async {
    data = await FileHandle.getAndSaveCache("theme", "theme");
  }
}

bool get darkMode =>true;
    // Data.app.get("dark_mode", true); //; //AppTheme.data["dark_mode"] ?? false;
set darkMode(v) {
  Data.app.put("dark_mode", v);
}

Color get primary => _c("primary");
Color get pri => primary;
Color get secondary => _c("secondary");
Color get sec => secondary;
Color get tertiary => _c("tertiary");
Color get ter => tertiary;
Color get normal => _c("normal");
Color get nor => normal;

String get faSg => AppTheme.data["default_font_family"] ?? "Space Grotesk";
bool get enableDebugBox => AppTheme.data["enable_debug_box"] ?? false;
bool get enableLiquidGlass => AppTheme.data["enable_liquid_glass"] ?? false;

Color get debugColor => hexColor(AppTheme.data["debug_color"]);
Color get debugColor2 => hexColor(AppTheme.data["debug_color_2"]);

Color get bg1 => _c("bg1");
Color get bg1_5 => _c("bg1_5");
Color get bg2 => _c("bg2");
Color get bg3 => _c("bg3");
Color get bg4 => _c("bg4");
Color get bg5 => _c("bg5");

Color get so1 => _c("so1");

Color get tx1 => _c("tx1");
Color get tx1p => _c("tx1p");
Color get tx2 => _c("tx2");
Color get tx2p => _c("tx2p");
Color get tx3 => _c("tx3");
Color get tx4 => _c("tx4");
Color get tx5 => _c("tx5");
Color get tx6 => _c("tx6");
Color get tx6p => _c("tx6p");

Color get background1 => _c("background1");
Color get background2 => _c("background2");
Color get background3 => _c("background3");
Color get background4 => _c("background4");

Color _c(String key) {
  final List list = AppTheme.data[key];
  final String hex = darkMode ? list[0] : list[1];
  return hexColor(hex);
}

Color primaryStyle = decideStyle(primary);
