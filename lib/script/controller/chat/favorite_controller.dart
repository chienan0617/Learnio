import 'package:learnio/script/types/chat_message.dart';
import 'package:learnio/script/types/conversation.dart';

class FavoriteController {
  void Function()? onStateChanged;

  List<ChatMessage> getFavorites(List<Conversation> conversations) {
    final favorites = <ChatMessage>[];
    for (final conv in conversations) {
      for (final msg in conv.messages) {
        if (msg.isFavorite) {
          favorites.add(msg);
        }
      }
    }
    favorites.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return favorites;
  }

  void toggleFavorite(ChatMessage message) {
    message.isFavorite = !message.isFavorite;
    onStateChanged?.call();
  }

  String getConversationTitle(String conversationId, List<Conversation> conversations) {
    for (final conv in conversations) {
      if (conv.id == conversationId) return conv.title;
    }
    return '未知對話';
  }
}
