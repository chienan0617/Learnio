import 'package:learnio/base.dart';

class Rebuild {
  static final Map<String, VoidCallback> states = {};
  static final Map<String, Function()> functions = {};

  static void register(String key, VoidCallback value) {
    states[key] = value;
  }

  static void registerFunction(String key, Function() func) {
    functions[key] = func;
  }

  static void _callAll(List<String> keys) {
    for (var key in keys) {
      _call(key);
    }
  }

  static void _call(String key) {
    if (key.contains("%")) {
      String k = key.replaceAll(r'%', r'');
      if (functions.containsKey(k)) {
        functions[k]!.call();
      }
    } else if (states.containsKey(key)) {
      states[key]!.call();
    } else {
      if (System.debugMode) {
        throw NotFoundTargetException(key);
      }
    }
  }
}

class SourcePath extends Rebuild {
  final List<String> sources;

  SourcePath(this.sources);

  factory SourcePath.empty() {
    return SourcePath([]);
  }

  void callAll() {
    Rebuild._callAll(sources);
  }
}

extension RebuildExtension on State {
  void Function() getRebuild() =>
      // ignore: invalid_use_of_protected_member
      () => setState(() {});

  void registerRebuild(String key) => Rebuild.register(key, getRebuild());
}

void rebuild(String key) {
  SourcePath([key]).callAll();
}
