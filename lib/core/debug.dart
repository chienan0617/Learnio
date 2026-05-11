import 'dart:developer' as dev;

import 'package:learnio/base.dart';

class Debug {
  static void log(Object object) {
    dev.log(
      '[${DateTime.now().toString().substring(9, 15)}] ${object.toString()}',
    );
  }
}

dynamic todo([Object? obj]) {
  if (!System.debugMode) throw Exception();
  if (System.debugMode) return obj;
}

void logE(Object object) {
  dev.log(object.toString());
}
