import 'package:learnio/base.dart';

part 'learning_item.g.dart';

@HiveType(typeId: 53)
class LearningItem {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String summary;

  @HiveField(3)
  final String? sourceMessageId;

  @HiveField(4)
  final List<String> tags;

  @HiveField(5)
  final DateTime createdAt;

  LearningItem({
    required this.id,
    required this.title,
    required this.summary,
    this.sourceMessageId,
    List<String>? tags,
    required this.createdAt,
  }) : tags = tags ?? [];
}
