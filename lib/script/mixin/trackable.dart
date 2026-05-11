import 'package:learnio/base.dart';
import 'package:learnio/script/types/trackable.dart';

mixin TrackableMixin {
  static final random = Random();

  static void updateLastEditTime<T extends TrackableData>(T trackable) {
    trackable.lastEditTime = now().millisecondsSinceEpoch;
    trackable.editTimes += 1;
  }

  static int randomID() {
    final rand = random.nextInt(1 << 31);
    final timePart = DateTime.now().microsecondsSinceEpoch & 0x7FFFFFFF;
    return (rand ^ timePart) & 0x7FFFFFFF;
  }
}
