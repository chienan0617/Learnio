import 'package:learnio/base.dart';

class Tutorial implements Initialable {
  static final Map<String, TutorialCoachMark> tutorials = {};
  static final Map<String, GlobalKey> globalKeys = {};
  static final Map<String, dynamic> words = {};
  static final String langName = Language.langName;

  static bool initialized = false;
  static final Set<String> shownTutorials = {};

  static Future<void> initialize() async {
    if (!initialized) {
      await _initialize();
    }
  }

  static Future<void> _initialize() async {
    words[langName] = await FileHandle.getTutorialKeysLang(langName);
    final data = await FileHandle.getTutorialKeys();

    for (var entry in data.entries) {
      final moduleName = entry.key;
      final stepsMap = Map<String, dynamic>.from(entry.value);

      createKeys(moduleName, stepsMap);
      final targets = buildTargets(moduleName, stepsMap);

      tutorials[moduleName] = TutorialCoachMark(
        targets: targets,
        colorShadow: tx1,
        opacityShadow: 0.7,
        textSkip: words[langName]['skip'] ?? '跳過',
        alignSkip: Alignment.topRight,
        focusAnimationDuration: Duration(milliseconds: 600),
        pulseAnimationDuration: Duration(milliseconds: 500),
        useSafeArea: true,
        onFinish: () {
          debugPrint('$moduleName tutorial finish');
        },
        textStyleSkip: TextStyle(
          color: tx1,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        onSkip: () => true,
      );

      // log('GlobalKeys: $globalKeys');
      // log('Tutorials: ${tutorials.keys}');
    }
  }

  static void createKeys(String moduleName, Map<String, dynamic> steps) {
    for (var step in steps.keys) {
      final fullKey = step.contains(':') ? step : '$moduleName:$step';
      if (!globalKeys.containsKey(fullKey)) {
        globalKeys[fullKey] = GlobalKey();
      }
    }
  }

  static List<TargetFocus> buildTargets(
    String moduleName,
    Map<String, dynamic> steps,
  ) {
    final List<TargetFocus> list = [];

    for (var entry in steps.entries) {
      final rawStep = entry.key;
      final fullKey = rawStep.contains(':') ? rawStep : '$moduleName:$rawStep';
      final config = List<dynamic>.from(entry.value);
      // 0: ContentAlign 索引, 1: 文案 key, 2: shape type (0 圓形,1 圓角矩形), 3: radius (若為圓角矩形)
      final align = ContentAlign.values[config[0] as int];
      final textKey = config[1] as String;
      final intro = textKey;
      final shapeType = config.length >= 3 ? config[2] as int : 0;
      final radius = config.length >= 4 ? (config[3] as num).toDouble() : 8.0;
      final shape = shapeType == 0
          ? ShapeLightFocus.Circle
          : ShapeLightFocus.RRect;

      list.add(
        TargetFocus(
          keyTarget: globalKeys[fullKey]!,
          identify: fullKey,
          shape: shape,
          radius: radius,
          paddingFocus: 8,
          enableOverlayTab: true,
          contents: [
            TargetContent(
              align: align,
              builder: (context, controller) => text(
                intro,
                20,
                fw6,
                tx1,
              ),
            ),
          ],
        ),
      );
    }

    return list;
  }

  static GlobalKey getKey(String module, String step) {
    return globalKeys['$module:$step']!;
  }

  static Widget warp(Widget w, String module, String step) {
    final String fullKey = '$module:$step';

    // 檢查是否已經看過教學 (從你之前的 Data 類或 shownTutorials 判斷)
    // 如果教學已經結束，直接回傳原 Widget，不要帶 Key
    bool isFinished =
        shownTutorials.contains(module) ||
        (Data.app.get('tutorial:$module') ?? false);

    if (isFinished || !globalKeys.containsKey(fullKey)) {
      return w;
    }

    // 使用 KeyedSubtree 代替 Container，效能更好且不會影響佈局
    return KeyedSubtree(key: globalKeys[fullKey], child: w);
  }

  static void showTutorial(BuildContext context, String moduleName) {
    if (Data.app.get('tutorial:$moduleName', false)) return;

    final tutorial = tutorials[moduleName];
    if (tutorial != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        tutorial.show(context: context);
      });
    }

    Data.app.put('tutorial:$moduleName', false);
  }
}
