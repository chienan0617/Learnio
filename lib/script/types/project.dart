import 'package:learnio/base.dart';

class Project {
  final String id;
  String name;
  String description;
  final List<String> conversationIds;
  final DateTime createdAt;
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
