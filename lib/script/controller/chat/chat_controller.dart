import 'package:learnio/core/debug.dart';
import 'package:learnio/script/types/chat_message.dart';
import 'package:learnio/script/types/conversation.dart';
import 'package:learnio/script/types/ai_model.dart';
import 'package:learnio/script/controller/chat/conversation_controller.dart';
import 'package:learnio/script/controller/service/chat_api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

typedef VoidCallbackSimple = void Function();

class ChatController {
  final ConversationController _conversationController;
  final ChatApiService _chatApiService = ChatApiService();
  VoidCallbackSimple? onStateChanged;

  ChatController(this._conversationController) {
    fetchModels();
  }

  Conversation? get current => _conversationController.current;
  List<ChatMessage> get messages => current?.messages ?? [];
  bool get isIncognito => _conversationController.isIncognito;

  bool _isGenerating = false;
  bool get isGenerating => _isGenerating;
  bool _isStopping = false;

  /// Returns true only when the AI is processing but hasn't started outputting text.
  bool get isThinking => _isGenerating && (messages.isEmpty || messages.last.role != MessageRole.assistant || messages.last.content.isEmpty);

  AiModel? _selectedModelObj;
  String get selectedModel => _selectedModelObj?.name ?? 'Gemini 2.5 Pro';
  AiModel? get selectedModelObj => _selectedModelObj;

  List<AiModel> _availableModels = [];
  List<AiModel> get availableModels => _availableModels;

  bool _isLoadingModels = false;
  bool get isLoadingModels => _isLoadingModels;

  Future<void> fetchModels() async {
    _isLoadingModels = true;
    onStateChanged?.call();

    try {
      final response = await http.get(Uri.parse(
          'https://chienan0617.github.io/layout/dev.cas.learnio/models/models_list.json'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _availableModels = data
            .map((json) => AiModel.fromJson(json))
            .where((m) => m.enable)
            .toList();

        // 設置初始選中模型
        if (_availableModels.isNotEmpty) {
          // 優先匹配當前對話的模型
          if (current != null) {
            _selectedModelObj = _availableModels.firstWhere(
              (m) => m.id == current!.modelName || m.name == current!.modelName,
              orElse: () => _availableModels.first,
            );
          } else {
            _selectedModelObj = _availableModels.first;
          }
        }
      }
    } catch (e) {
      logE('Failed to fetch models: $e');
    } finally {
      _isLoadingModels = false;
      onStateChanged?.call();
    }
  }

  void selectModel(AiModel model) {
    _selectedModelObj = model;
    if (current != null) {
      current!.modelName = model.id;
    }
    onStateChanged?.call();
  }

  /// 同步選中的模型物件與當前對話的模型名稱
  void syncSelectedModel() {
    if (_availableModels.isEmpty) return;

    if (current != null) {
      _selectedModelObj = _availableModels.firstWhere(
        (m) => m.id == current!.modelName || m.name == current!.modelName,
        orElse: () => _availableModels.first,
      );
    } else {
      _selectedModelObj = _availableModels.first;
    }
    onStateChanged?.call();
  }

  void stopGeneration() {
    if (_isGenerating) {
      _isStopping = true;
      onStateChanged?.call();
    }
  }

  Future<void> sendMessage(String content, {List<String>? images, List<String>? files, List<String>? links}) async {
    if (content.trim().isEmpty && (images == null || images.isEmpty) && (files == null || files.isEmpty) && (links == null || links.isEmpty)) return;

    // 如果沒有當前對話，建立新的
    if (current == null) {
      _conversationController.createConversation(
        title: content.length > 30 ? '${content.substring(0, 30)}...' : content,
      );
      // Ensure the model is set for the new conversation
      if (_selectedModelObj != null) {
        current!.modelName = _selectedModelObj!.id;
      }
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
    _isStopping = false;
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
    _isStopping = false;
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
      final stream = _chatApiService.getChatStream(
        current!,
        gateway: _selectedModelObj?.gateway,
      );

      String fullContent = '';
      bool hasReceivedData = false;

      await for (final chunk in stream) {
        if (_isStopping) {
          fullContent += '\n\n*(已終止對話)*';
          final idx = current!.messages.indexWhere((m) => m.id == aiMsgId);
          if (idx != -1) {
            current!.messages[idx] = aiMsg.copyWith(content: fullContent);
          }
          break;
        }

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

      if (!hasReceivedData && !_isStopping) {
        throw Exception('未收到來自伺服器的回應');
      }
    } catch (e) {
      if (!_isStopping) {
        final idx = current!.messages.indexWhere((m) => m.id == aiMsgId);
        if (idx != -1) {
          current!.messages[idx] = aiMsg.copyWith(
            content: '抱歉，處理您的請求時發生錯誤。\n\n詳細資訊：$e',
            isError: true,
          );
        }
      }
    } finally {
      current!.updatedAt = DateTime.now();
      _isGenerating = false;
      _isStopping = false;
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
