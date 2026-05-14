import 'package:learnio/base.dart';
import 'package:learnio/script/types/chat_message.dart';

part 'conversation.g.dart';

@HiveType(typeId: 52)
class Conversation {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  final List<ChatMessage> messages;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  @HiveField(5)
  String modelName;

  @HiveField(6)
  String? projectId;

  Conversation({
    required this.id,
    required this.title,
    List<ChatMessage>? messages,
    required this.createdAt,
    required this.updatedAt,
    this.modelName = 'Gemini 2.5 Pro',
    this.projectId,
  }) : messages = messages ?? [];

  String get preview {
    if (messages.isEmpty) return '空對話';
    final last = messages.last;
    final text = last.content;
    return text.length > 60 ? '${text.substring(0, 60)}...' : text;
  }

  String get timeLabel {
    final now = DateTime.now();
    final diff = now.difference(updatedAt);
    if (diff.inMinutes < 1) return '剛剛';
    if (diff.inHours < 1) return '${diff.inMinutes} 分鐘前';
    if (diff.inDays < 1) return '${diff.inHours} 小時前';
    if (diff.inDays < 7) return '${diff.inDays} 天前';
    return '${updatedAt.month}/${updatedAt.day}';
  }
}
