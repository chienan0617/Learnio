import 'package:learnio/base.dart';

part 'project.g.dart';

@HiveType(typeId: 54)
class Project {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  final List<String> conversationIds;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final Color color;

  Project({
    required this.id,
    required this.name,
    this.description = '',
    List<String>? conversationIds,
    required this.createdAt,
    required this.color,
  }) : conversationIds = conversationIds ?? [];

  int get conversationCount => conversationIds.length;
}
