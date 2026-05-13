class LearningItem {
  final String id;
  String title;
  String summary;
  final String? sourceMessageId;
  final List<String> tags;
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
