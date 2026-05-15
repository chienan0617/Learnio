import 'package:learnio/base.dart';
import 'package:learnio/script/types/chat_message.dart';
import 'package:learnio/script/types/conversation.dart';
import 'api_service_controller.dart';

/// High-level service to handle chat-specific API logic.
class ChatApiService {
  final ApiServiceController _apiController = ApiServiceController();

  /// Streams the response for a given conversation.
  Stream<String> getChatStream(Conversation conversation, {String? gateway}) {
    final messages = conversation.messages.map((m) => {
      'role': _mapRole(m.role),
      'content': m.content,
      if (m.images != null && m.images!.isNotEmpty) 'images': m.images,
      if (m.files != null && m.files!.isNotEmpty) 'files': m.files,
      if (m.links != null && m.links!.isNotEmpty) 'links': m.links,
    }).toList();

    return _apiController.streamChat(
      messages: messages,
      model: conversation.modelName,
      gateway: gateway,
    );
  }

  String _mapRole(MessageRole role) {
    switch (role) {
      case MessageRole.user:
        return 'user';
      case MessageRole.assistant:
        return 'assistant';
      case MessageRole.system:
        return 'system';
    }
  }
}
