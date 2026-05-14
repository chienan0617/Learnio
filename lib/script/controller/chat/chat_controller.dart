import 'package:learnio/script/types/chat_message.dart';
import 'package:learnio/script/types/conversation.dart';
import 'package:learnio/script/controller/chat/conversation_controller.dart';
import 'package:learnio/script/controller/service/chat_api_service.dart';

typedef VoidCallbackSimple = void Function();

class ChatController {
  final ConversationController _conversationController;
  final ChatApiService _chatApiService = ChatApiService();
  VoidCallbackSimple? onStateChanged;

  ChatController(this._conversationController);

  Conversation? get current => _conversationController.current;
  List<ChatMessage> get messages => current?.messages ?? [];
  bool get isIncognito => _conversationController.isIncognito;

  bool _isGenerating = false;
  bool get isGenerating => _isGenerating;

  /// Returns true only when the AI is processing but hasn't started outputting text.
  bool get isThinking => _isGenerating && (messages.isEmpty || messages.last.role != MessageRole.assistant || messages.last.content.isEmpty);

  String _selectedModel = 'Gemini 2.5 Pro';
  String get selectedModel => _selectedModel;
  static const List<String> availableModels = [
    'Gemini 2.5 Pro',
    'Gemini 2.5 Flash',
    'GPT-4o',
    'Claude Sonnet',
  ];

  void selectModel(String model) {
    _selectedModel = model;
    if (current != null) {
      current!.modelName = model;
    }
    onStateChanged?.call();
  }

  Future<void> sendMessage(String content, {List<String>? images, List<String>? files, List<String>? links}) async {
    if (content.trim().isEmpty && (images == null || images.isEmpty) && (files == null || files.isEmpty) && (links == null || links.isEmpty)) return;

    // 如果沒有當前對話，建立新的
    if (current == null) {
      _conversationController.createConversation(
        title: content.length > 30 ? '${content.substring(0, 30)}...' : content,
      );
    }

    final userMsg = ChatMessage(
      id: _generateId(),
      conversationId: current!.id,
      role: MessageRole.user,
      content: content.trim(),
      timestamp: DateTime.now(),
      images: images,
      files: files,
      links: links,
    );

    current!.messages.add(userMsg);
    current!.updatedAt = DateTime.now();

    // 自動更新標題 (如果是第一則訊息)
    if (current!.messages.length == 1) {
      current!.title = content.length > 30
          ? '${content.substring(0, 30)}...'
          : content;
    }

    _isGenerating = true;
    onStateChanged?.call();

    // 呼叫真實 API 回應
    await _fetchAiResponse(images: images, files: files, links: links);
  }

  Future<void> retryMessage(String messageId) async {
    final idx = current!.messages.indexWhere((m) => m.id == messageId);
    if (idx == -1) return;

    final msg = current!.messages[idx];
    if (!msg.isError) return;

    // Remove the error message
    current!.messages.removeAt(idx);
    
    _isGenerating = true;
    onStateChanged?.call();

    // Re-fetch response
    await _fetchAiResponse();
  }

  Future<void> _fetchAiResponse({List<String>? images, List<String>? files, List<String>? links}) async {
    final aiMsgId = _generateId();
    final aiMsg = ChatMessage(
      id: aiMsgId,
      conversationId: current!.id,
      role: MessageRole.assistant,
      content: '',
      timestamp: DateTime.now(),
    );

    current!.messages.add(aiMsg);

    try {
      final stream = _chatApiService.getChatStream(current!, images: images, files: files, links: links);

      String fullContent = '';
      bool hasReceivedData = false;

      await for (final chunk in stream) {
        if (chunk.startsWith('Error:')) {
          throw Exception(chunk.replaceFirst('Error:', '').trim());
        }

        hasReceivedData = true;
        fullContent += chunk;

        // 更新訊息內容
        final idx = current!.messages.indexWhere((m) => m.id == aiMsgId);
        if (idx != -1) {
          current!.messages[idx] = aiMsg.copyWith(content: fullContent);
        }

        onStateChanged?.call();
      }

      if (!hasReceivedData) {
        throw Exception('未收到來自伺服器的回應');
      }
    } catch (e) {
      final idx = current!.messages.indexWhere((m) => m.id == aiMsgId);
      if (idx != -1) {
        current!.messages[idx] = aiMsg.copyWith(
          content: '抱歉，處理您的請求時發生錯誤。\n\n詳細資訊：$e',
          isError: true,
        );
      }
    } finally {
      current!.updatedAt = DateTime.now();
      _isGenerating = false;
      onStateChanged?.call();
    }
  }


  void toggleFavorite(String messageId) {
    if (current == null) return;
    final idx = current!.messages.indexWhere((m) => m.id == messageId);
    if (idx != -1) {
      current!.messages[idx].isFavorite = !current!.messages[idx].isFavorite;
      onStateChanged?.call();
    }
  }

  int _idCounter = 0;
  String _generateId() {
    _idCounter++;
    return 'msg_${DateTime.now().millisecondsSinceEpoch}_$_idCounter';
  }
}
