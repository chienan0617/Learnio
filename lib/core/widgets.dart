import 'package:learnio/base.dart';

SizedBox width([v = 0.0]) => SizedBox(width: v.toDouble());
SizedBox height([v = 0.0]) => SizedBox(height: v.toDouble());
SizedBox box([w = 0.0, h = 0.0, Widget? c, Key? key]) =>
    SizedBox(key: key, width: w.toDouble(), height: h.toDouble(), child: c);
SizedBox boxV(v) => SizedBox(child: v);

Size size(ctx) => MediaQuery.of(ctx).size;

Text text(
  String msg, [
  double size = 16,
  FontWeight weight = fw5,
  Color? color,
  bool translate = false,
  String? fontFamily,
  FontStyle style = fsN,
  TextAlign align = TextAlign.start,
  int? maxLines,
  TextOverflow overflow = TextOverflow.clip,
  double? ls,
  Key? key,
]) => Text(
  translate ? word(msg) : msg,
  key: key,
  textAlign: align,
  maxLines: maxLines,
  overflow: overflow,
  style: TextStyle(
    fontSize: size,
    fontWeight: weight,
    fontStyle: style,
    color: color ?? tx1,
    letterSpacing: ls,
    fontFamily: fontFamily,
  ),
);

Text textNt(
  String msg, [
  double size = 16,
  FontWeight weight = fw5,
  Color? color,
  String? family,
  FontStyle style = fsN,
]) => text(msg, size, weight, color, false, family, style);

Text textD(
  String msg, [
  double size = 16,
  FontWeight weight = fw5,
  Color? color,
  String? family,
  FontStyle style = fsN,
]) => System.debugMode
    ? textNt(msg, size, weight, color, family, style)
    : throw DebugError();

BorderRadius borderCircular(double v) => BorderRadius.circular(v);
EdgeInsets symmetricH(double v) => EdgeInsets.symmetric(horizontal: v);
EdgeInsets symmetricV(double v) => EdgeInsets.symmetric(vertical: v);
EdgeInsets symmetric(double h, double v) =>
    EdgeInsets.symmetric(horizontal: h, vertical: v);
EdgeInsets symmetricAll(double v) => EdgeInsets.all(v);

Center center(Widget v) => Center(child: v);

Expanded expand([Widget? v, int f = 1]) => Expanded(flex: f, child: v ?? box());
Spacer spacer() => Spacer();
// Expanded expandV(v) => Expanded(child: v);

Card card(Widget v) => Card(child: v);

SingleChildScrollView scroll(Widget v, [ScrollPhysics? p]) =>
    SingleChildScrollView(physics: p, child: v);

Icon icon(IconData icon, [double size = 20, Color? color, FontWeight? fw]) =>
    Icon(icon, size: size, color: color ?? tx1, fontWeight: fw);

Widget logo([double size = 20, Color? color]) => true
    ? Icon(Icons.auto_awesome, size: size, color: color)
    : Image.asset(
        'assets/icon/icon.webp',
        width: size,
        height: size,
        color: color,
      );

IconButton iconButton(
  Widget icon,
  VoidCallback? fn, {
  Color? color,
  double? size,
  Key? key,
}) => IconButton(
  key: key,
  onPressed: fn,
  icon: icon,
  color: color,
  iconSize: size,
);

// Widget liquidGlass(
//   Widget c, {
//   double b = 15,
//   double t = 20,
//   double r = 10,
//   bool cr = false,
// }) => enableLiquidGlass
//     ? LiquidGlassLayer(
//         settings: LiquidGlassSettings(blur: b, thickness: t),
//         child: LiquidGlass(
//           shape: cr ? LiquidOval() : LiquidRoundedRectangle(borderRadius: r),
//           child: c,
//         ),
//       )
//     : c;

InkWell inkWell(
  Widget v,
  VoidCallback? fn, {
  BorderRadius? radius,
  VoidCallback? onLongPress,
  Color splash = transparent,
  Color? focus,
  Color? hover,
}) => InkWell(
  onTap: fn,
  onLongPress: onLongPress,
  borderRadius: radius,
  splashColor: splash,
  focusColor: focus,
  hoverColor: hover,
  child: v,
);

GestureDetector gestureDetector(Widget v, [tap, longPress]) =>
    GestureDetector(onTap: tap, onLongPress: longPress, child: v);

Widget container(
  Widget v, {
  Key? key,
  double? width,
  double? height,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  Color? color,
  BorderRadiusGeometry? radius,
  BoxBorder? border,
  List<BoxShadow>? shadow,
  AlignmentGeometry? alignment,
  Gradient? gradient,
  DecorationImage? image,
  BoxShape shape = BoxShape.rectangle,
  Clip clip = Clip.none,
}) => Container(
  key: key,
  width: width,
  height: height,
  padding: padding,
  margin: margin,
  alignment: alignment,
  clipBehavior: clip,
  decoration: BoxDecoration(
    color: color,
    image: image,
    borderRadius: shape == BoxShape.circle ? null : radius,
    border: border,
    boxShadow: shadow,
    gradient: gradient,
    shape: shape,
  ),
  child: v,
);

Widget debugBox(Widget v) => enableDebugBox
    ? Container(
        decoration: BoxDecoration(border: BoxBorder.all(color: debugColor)),
        child: v,
      )
    : v;

Column column(
  List<Widget> c, {
  Key? key,
  MainAxisAlignment ma = MainAxisAlignment.start,
  CrossAxisAlignment ca = CrossAxisAlignment.start,
  MainAxisSize ms = MainAxisSize.min,
}) => Column(
  key: key,
  mainAxisAlignment: ma,
  crossAxisAlignment: ca,
  mainAxisSize: ms,
  children: c,
);

Row row(
  List<Widget> c, {
  Key? key,
  MainAxisAlignment ma = MainAxisAlignment.start,
  CrossAxisAlignment ca = CrossAxisAlignment.start,
  MainAxisSize ms = MainAxisSize.min,
}) => Row(
  key: key,
  mainAxisAlignment: ma,
  crossAxisAlignment: ca,
  mainAxisSize: ms,
  children: c,
);

Stack stack(
  List<Widget> c, {
  Key? key,
  AlignmentGeometry a = Alignment.center,
}) => Stack(key: key, alignment: a, children: c);

Positioned positioned(
  Widget c, {
  num? l,
  num? t,
  num? r,
  num? b,
  num? w,
  num? h,
}) {
  return Positioned(
    left: l?.toDouble(),
    top: t?.toDouble(),
    right: r?.toDouble(),
    bottom: b?.toDouble(),
    width: w?.toDouble(),
    height: h?.toDouble(),
    child: c,
  );
}

Positioned positionedFill(Widget c, {num? l, num? t, num? r, num? b}) {
  return Positioned.fill(
    left: l?.toDouble(),
    top: t?.toDouble(),
    right: r?.toDouble(),
    bottom: b?.toDouble(),
    child: c,
  );
}

Widget adaptive({
  Widget? general,
  Widget? ios,
  Widget? android,
  Widget? web,
  Widget? desktop,
}) {
  if ([general, ios, android, web, desktop].map((e) => e != null).isEmpty) {
    throw IllegalArgumentError();
  }
  Widget? platformWidget;

  if (kIsWeb) {
    platformWidget = web;
  } else if (Platform.isAndroid) {
    platformWidget = android;
  } else if (Platform.isIOS) {
    platformWidget = ios;
  } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    platformWidget = desktop;
  }

  if (platformWidget != null) {
    return platformWidget;
  }

  if (general != null) {
    return general;
  }

  return (ios ?? android ?? web ?? desktop)!;
}

Widget dot(Color c, double s) => Container(
  width: s,
  height: s,
  decoration: BoxDecoration(shape: BoxShape.circle, color: c),
);

Padding padding(EdgeInsets p, Widget c, {Key? key}) =>
    Padding(key: key, padding: p, child: c);

@Deprecated("some problem needed to be fix")
Future<dynamic> pushScene(scene, ctx) =>
    Navigator.push(ctx, MaterialPageRoute(builder: (_) => scene));

void popPage(ctx) => Navigator.pop(ctx);

Widget flexible(
  BuildContext ctx, {
  Widget? desktop,
  Widget? mobile,
  Widget? web,
  Widget? general,
}) {
  final Size size = MediaQuery.of(ctx).size;
  final double width = size.width;

  const double desktopBreakpoint = 1024;
  const double webBreakpoint = 600; // maybe tablet/large phone

  Widget? chosen;

  if (width >= desktopBreakpoint) {
    chosen = desktop ?? general;
  } else if (width >= webBreakpoint) {
    chosen = web ?? general;
  } else {
    chosen = mobile ?? general;
  }

  chosen ??= const SizedBox.shrink();

  return chosen;
}
