import 'package:learnio/script/controller/data/data_controller.dart';
import 'package:learnio/script/types/chat_message.dart';
import 'package:learnio/script/types/conversation.dart';

class ConversationController {
  final List<Conversation> _conversations = [];
  Conversation? _current;
  void Function()? onStateChanged;
  bool _isIncognito = false;

  List<Conversation> get conversations => List.unmodifiable(_conversations);
  Conversation? get current => _current;
  bool get isIncognito => _isIncognito;

  ConversationController() {
    _loadFromStorage();
  }

  void setIncognito(bool value) {
    if (_isIncognito == value) return;
    _isIncognito = value;
    
    // Switch to a new session when entering/leaving incognito
    _current = null;
    onStateChanged?.call();
  }

  void _loadFromStorage() {
    final stored = DataController.getConversations();
    if (stored.isEmpty) {
      _loadMockData();
    } else {
      _conversations.addAll(stored);
      _conversations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }
  }

  Conversation createConversation({String title = '新對話'}) {
    final conv = Conversation(
      id: _isIncognito 
          ? 'incognito_${DateTime.now().millisecondsSinceEpoch}'
          : 'conv_${DateTime.now().millisecondsSinceEpoch}',
      title: _isIncognito ? '無痕對話' : title,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    if (!_isIncognito) {
      _conversations.insert(0, conv);
      DataController.saveConversation(conv);
    }
    
    _current = conv;
    onStateChanged?.call();
    return conv;
  }

  void renameConversation(String id, String newTitle) {
    if (id.startsWith('incognito_')) return; // Incognito conversations can't be renamed/saved
    
    final index = _conversations.indexWhere((c) => c.id == id);
    if (index != -1) {
      _conversations[index].title = newTitle;
      updateConversation(_conversations[index]);
    }
  }

  void updateConversation(Conversation conversation) {
    conversation.updatedAt = DateTime.now();
    if (!conversation.id.startsWith('incognito_')) {
      DataController.saveConversation(conversation);
    }
    onStateChanged?.call();
  }

  void selectConversation(String id) {
    final conv = _conversations.firstWhere(
      (c) => c.id == id,
      orElse: () => _conversations.first,
    );
    _current = conv;
    onStateChanged?.call();
  }

  void deleteConversation(String id) {
    _conversations.removeWhere((c) => c.id == id);
    DataController.deleteConversation(id);
    if (_current?.id == id) {
      _current = _conversations.isNotEmpty ? _conversations.first : null;
    }
    onStateChanged?.call();
  }

  void startNewConversation() {
    _current = null;
    onStateChanged?.call();
  }

  void _loadMockData() {
    final now = DateTime.now();

    // 對話 1
    final conv1 = Conversation(
      id: 'conv_mock_1',
      title: 'Flutter Widget 生命週期',
      createdAt: now.subtract(const Duration(hours: 2)),
      updatedAt: now.subtract(const Duration(hours: 2)),
    );
    conv1.messages.addAll([
      ChatMessage(
        id: 'msg_m1',
        conversationId: conv1.id,
        role: MessageRole.user,
        content: '可以解釋一下 Flutter Widget 的生命週期嗎？',
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
      ChatMessage(
        id: 'msg_m2',
        conversationId: conv1.id,
        role: MessageRole.assistant,
        content: '## StatefulWidget 生命週期\n\n'
            'StatefulWidget 的生命週期主要有以下階段：\n\n'
            '1. **createState()** — 建立 State 物件\n'
            '2. **initState()** — 初始化狀態，只呼叫一次\n'
            '3. **didChangeDependencies()** — 依賴變化時呼叫\n'
            '4. **build()** — 構建 Widget 樹\n'
            '5. **didUpdateWidget()** — Widget 配置更新時呼叫\n'
            '6. **setState()** — 觸發重建\n'
            '7. **dispose()** — 清理資源\n\n'
            '需要更詳細的說明嗎？',
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
    ]);

    // 對話 2
    final conv2 = Conversation(
      id: 'conv_mock_2',
      title: 'Dart 異步程式設計',
      createdAt: now.subtract(const Duration(days: 1)),
      updatedAt: now.subtract(const Duration(days: 1)),
    );
    conv2.messages.addAll([
      ChatMessage(
        id: 'msg_m3',
        conversationId: conv2.id,
        role: MessageRole.user,
        content: 'async/await 和 Future 有什麼關係？',
        timestamp: now.subtract(const Duration(days: 1)),
      ),
      ChatMessage(
        id: 'msg_m4',
        conversationId: conv2.id,
        role: MessageRole.assistant,
        content: '## Future 與 async/await\n\n'
            '`Future` 是 Dart 中表示異步操作的核心類別。`async/await` 是讓異步代碼看起來像同步代碼的語法糖。\n\n'
            '```dart\n'
            '// 使用 Future.then()\n'
            'fetchData().then((data) => print(data));\n\n'
            '// 使用 async/await（推薦）\n'
            'final data = await fetchData();\n'
            'print(data);\n'
            '```\n\n'
            '兩者是等價的，但 async/await 更易讀。',
        timestamp: now.subtract(const Duration(days: 1)),
      ),
    ]);

    final mockData = [conv1, conv2];
    _conversations.addAll(mockData);
    for (var c in mockData) {
      DataController.saveConversation(c);
    }
  }
}
