import 'package:learnio/script/types/chat_message.dart';
import 'package:learnio/script/types/conversation.dart';
import 'package:learnio/script/controller/chat/conversation_controller.dart';

typedef VoidCallbackSimple = void Function();

class ChatController {
  final ConversationController _conversationController;
  VoidCallbackSimple? onStateChanged;

  ChatController(this._conversationController);

  Conversation? get current => _conversationController.current;
  List<ChatMessage> get messages => current?.messages ?? [];

  bool _isGenerating = false;
  bool get isGenerating => _isGenerating;

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

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

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

    // 模擬 AI 回應
    await _simulateAiResponse(content);
  }

  Future<void> _simulateAiResponse(String userContent) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    final response = _getMockResponse(userContent);

    final aiMsg = ChatMessage(
      id: _generateId(),
      conversationId: current!.id,
      role: MessageRole.assistant,
      content: response,
      timestamp: DateTime.now(),
    );

    current!.messages.add(aiMsg);
    current!.updatedAt = DateTime.now();
    _isGenerating = false;
    onStateChanged?.call();
  }

  String _getMockResponse(String input) {
    final lower = input.toLowerCase();

    if (lower.contains('hello') || lower.contains('你好') || lower.contains('hi')) {
      return '你好！👋 我是 Learnio AI 學習助手。我可以幫助你理解各種知識概念、解答問題、'
          '或者一起討論學習計劃。請問今天想學什麼呢？';
    }
    if (lower.contains('flutter')) {
      return '## Flutter 簡介\n\n'
          'Flutter 是 Google 開發的開源 UI 框架，使用 Dart 語言。它的核心優勢包括：\n\n'
          '- **跨平台開發** — 一套程式碼同時構建 iOS、Android、Web 和桌面應用\n'
          '- **熱重載 (Hot Reload)** — 即時看到代碼變更效果\n'
          '- **Widget 體系** — 一切皆為 Widget，組合式 UI 設計\n'
          '- **高效能** — 使用 Skia 渲染引擎，接近原生效能\n\n'
          '想深入了解哪個部分呢？我可以詳細解說。';
    }
    if (lower.contains('dart')) {
      return '## Dart 語言\n\n'
          'Dart 是一種由 Google 開發的程式語言，專為建構快速、多平台應用程式而設計。\n\n'
          '**關鍵特性：**\n'
          '- 強型別系統搭配型別推斷\n'
          '- 支援 async/await 異步程式設計\n'
          '- Null Safety 空安全\n'
          '- 支援 AOT 和 JIT 編譯\n\n'
          '需要我舉一些 Dart 的實際範例嗎？';
    }
    if (lower.contains('python')) {
      return '## Python\n\n'
          'Python 是一門廣泛使用的高階程式語言，以其簡潔、可讀的語法著稱。\n\n'
          '**常見應用領域：**\n'
          '- 🤖 機器學習與人工智能\n'
          '- 📊 資料科學與分析\n'
          '- 🌐 Web 開發（Django, Flask）\n'
          '- 🔧 自動化腳本\n\n'
          '你對 Python 的哪個方面最感興趣？';
    }
    if (lower.contains('學習') || lower.contains('learn')) {
      return '## 學習建議\n\n'
          '有效學習的幾個關鍵原則：\n\n'
          '1. **間隔重複** — 定期複習，避免一次性填鴉式學習\n'
          '2. **主動回想** — 嘗試回憶而非只是閱讀\n'
          '3. **費曼技巧** — 用自己的話解釋概念\n'
          '4. **專注時段** — 使用番茄工作法保持專注\n'
          '5. **連結知識** — 將新知識與已知概念建立聯繫\n\n'
          '想為特定主題制定學習計劃嗎？';
    }

    return '感謝你的提問！這是一個很好的問題。\n\n'
        '讓我從幾個角度來分析：\n\n'
        '**核心概念**\n'
        '每個複雜的問題都可以拆解為更小的部分來理解。建議你：\n\n'
        '1. 先釐清問題的本質\n'
        '2. 查找相關的基礎知識\n'
        '3. 嘗試動手實作或練習\n'
        '4. 總結並記錄你的理解\n\n'
        '需要我針對某個具體方面更深入地說明嗎？ 🎯';
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
