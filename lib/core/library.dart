library;

import 'package:learnio/base.dart';

// * Theme data

// List<int> get primaryColor {
// var primaryColorString = Data.app.getMap(T.setting)["primaryColor"] as String;
// return primaryColorString
//   .split(',')
//   .map((s) => int.parse(s.trim()))
// .toList();
// }

Color light({int o = 0}) => Color.fromRGBO(232 - o, 232 - o, 232 - o, 1);

Color dark({int o = 0}) => Color.fromRGBO(24 + o, 24 + o, 24 + o, 1);

@Deprecated("too old to use")
TextStyle textStyle({
  double size = 20,
  int os = 0,
  bool op = true,
  n = false,
}) => TextStyle(
  color: style(os: os, op: op, n: n),
  fontSize: size,
);

@Deprecated("use text() instead")
Text textDeprecated(
  String text, {
  double size = 16,
  FontWeight w = FontWeight.normal,
  os = -12,
  ml = 1,
}) => Text(
  text,
  style: TextStyle(
    fontSize: size,
    color: style(os: os),
    fontWeight: w,
  ),
  maxLines: ml,
);

FittedBox getErrorBox(String text, {color = Colors.red}) => FittedBox(
  child: Container(
    color: color,
    child: Text(text, style: TextStyle(color: Colors.white)),
  ),
);
IconThemeData getIconThemeData(double size, [Color? color, op = true]) =>
    IconThemeData(size: size, color: color ?? style());

Color style({bool op = true, int os = -12, bool n = false}) {
  if (n) {
    return op
        ? (darkMode ? light(o: os) : hexColor("#151922", os: os))
        : (darkMode ? hexColor("#151922", os: os) : light(o: os));
  } else {
    return op
        ? (darkMode ? hexColor("#F2F8FB", os: os) : dark(o: os))
        : (darkMode ? dark(o: os) : hexColor("#F2F8FB", os: os));
  }
}

double relativeLuminance(Color c) {
  double r = c.red / 255;
  double g = c.green / 255;
  double b = c.blue / 255;

  double lr = (r <= 0.03928)
      ? r / 12.92
      : pow((r + 0.055) / 1.055, 2.4).toDouble();
  double lg = (g <= 0.03928)
      ? g / 12.92
      : pow((g + 0.055) / 1.055, 2.4).toDouble();
  double lb = (b <= 0.03928)
      ? b / 12.92
      : pow((b + 0.055) / 1.055, 2.4).toDouble();

  return 0.2126 * lr + 0.7152 * lg + 0.0722 * lb;
}

Color decideStyle(Color bg) {
  final L = relativeLuminance(bg);
  final contrastWhite = (1 + 0.05) / (L + 0.05);
  final contrastBlack = (L + 0.05) / (0 + 0.05);

  return contrastWhite > contrastBlack ? Colors.white : Colors.black;
}

Container divider({
  double h = 0.5,
  double w = 20,
  double v = 5,
  // EdgeInsets edge = const EdgeInsets.fromLTRB(w, 0, w, 0),
  EdgeInsets mar = const EdgeInsets.symmetric(horizontal: 2.5),
}) => Container(
  margin: mar,
  child: Container(
    height: h.toDouble(),
    color: Colors.grey,
    margin: EdgeInsets.symmetric(horizontal: w, vertical: v),
  ),
);

@Deprecated("use another feature instead")
void setPrimaryColor(Color color) {
  // _primaryColor = color;
  // var t = Data.app.getMap(T.setting);
  // t["primaryColor"] =
  //     "${color.alpha},${color.red},${color.green},${color.blue}";
  // Data.app.storeMap(T.setting, t);
}

Color hexColor(String hex, {int os = 0}) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex';
  }

  if (hex.length == 8) {
    Color baseColor = Color(int.parse('0x$hex'));
    return adjustColor(baseColor, os);
  }
  return Colors.transparent;
}

Color hex(int h, {int os = 0}) {
  String hexString = h.toRadixString(16).padLeft(6, '0').toUpperCase();
  return hexColor(hexString, os: os);
}

EdgeInsets edge({double h = 0, double v = 0}) {
  return EdgeInsets.symmetric(horizontal: h, vertical: v);
}

Color adjustColor(Color color, int os) {
  int r = ((color.r * 255.0).round() & 0xff + os).clamp(0, 255).toInt();
  int g = ((color.g * 255.0).round() & 0xff + os).clamp(0, 255).toInt();
  int b = ((color.b * 255.0).round() & 0xff + os).clamp(0, 255).toInt();
  return Color.fromARGB(color.alpha, r, g, b);
}

Color colorStyle(Color color, [int os = 12]) {
  return (color.r + color.g + color.b) > 0.5 * 3 ? dark(o: os) : light(o: os);
}

// ignore: unused_element
Color _getOppositeColor(String hex) {
  Color color = hexColor(hex);
  int r = 255 - color.red;
  int g = 255 - color.green;
  int b = 255 - color.blue;
  return Color.fromARGB(color.alpha, r, g, b);
}

String rgba32ToHex(int rgba) {
  int r = (rgba >> 24) & 0xFF;
  int g = (rgba >> 16) & 0xFF;
  int b = (rgba >> 8) & 0xFF;
  int a = rgba & 0xFF;

  return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}${a.toRadixString(16).padLeft(2, '0')}';
}

int hexToRgba32(String hex) {
  hex = hex.replaceFirst('#', '');

  int r = int.parse(hex.substring(0, 2), radix: 16);
  int g = int.parse(hex.substring(2, 4), radix: 16);
  int b = int.parse(hex.substring(4, 6), radix: 16);
  int a = int.parse(hex.substring(6, 8), radix: 16);

  return (r << 24) | (g << 16) | (b << 8) | a;
}

ListTile getListTile(
  IconData leading,
  String title, {
  leadingSize = 20.0,
  titleSize = 20.0,
  IconData trailing = Icons.abc,
  trailingSize = 20.0,
  Function trailingFunc = none,
}) {
  return ListTile(
    leading: Icon(leading, color: style(), size: leadingSize),
    title: Text(
      title,
      style: TextStyle(color: style(), fontSize: titleSize),
    ),
    trailing: (trailing == Icons.abc)
        ? Container()
        : IconButton(
            onPressed: () {
              trailingFunc();
            },
            icon: Icon(trailing, color: style(), size: trailingSize),
          ),
  );
}
