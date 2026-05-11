
import 'package:learnio/base.dart';

part 'trackable.g.dart';

@HiveType(typeId: 48)
class TrackableData {
  @HiveField(16)
  final int id;

  @HiveField(17)
  final int createTime;

  @HiveField(18)
  int lastEditTime;

  @HiveField(19)
  int editTimes;

  TrackableData({
    required this.id,
    required this.createTime,
    required this.lastEditTime,
    required this.editTimes,
  });
}
