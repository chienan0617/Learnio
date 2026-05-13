import 'package:learnio/script/types/chat_message.dart';
import 'package:learnio/script/types/conversation.dart';

class ConversationController {
  final List<Conversation> _conversations = [];
  Conversation? _current;
  void Function()? onStateChanged;

  List<Conversation> get conversations => List.unmodifiable(_conversations);
  Conversation? get current => _current;

  ConversationController() {
    _loadMockData();
  }

  Conversation createConversation({String title = '新對話'}) {
    final conv = Conversation(
      id: 'conv_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _conversations.insert(0, conv);
    _current = conv;
    onStateChanged?.call();
    return conv;
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

    // 對話 3
    final conv3 = Conversation(
      id: 'conv_mock_3',
      title: '機器學習入門路線圖',
      createdAt: now.subtract(const Duration(days: 3)),
      updatedAt: now.subtract(const Duration(days: 3)),
      modelName: 'GPT-4o',
    );
    conv3.messages.addAll([
      ChatMessage(
        id: 'msg_m5',
        conversationId: conv3.id,
        role: MessageRole.user,
        content: '我想學機器學習，應該從哪裡開始？',
        timestamp: now.subtract(const Duration(days: 3)),
      ),
      ChatMessage(
        id: 'msg_m6',
        conversationId: conv3.id,
        role: MessageRole.assistant,
        content: '## 機器學習入門路線圖\n\n'
            '### 第一階段：數學基礎（2-4 週）\n'
            '- 線性代數基礎\n'
            '- 機率與統計\n'
            '- 微積分基礎\n\n'
            '### 第二階段：Python 程式設計（2-3 週）\n'
            '- NumPy, Pandas\n'
            '- Matplotlib 視覺化\n\n'
            '### 第三階段：ML 核心概念（4-6 週）\n'
            '- 監督式學習\n'
            '- 非監督式學習\n'
            '- scikit-learn 實作\n\n'
            '### 第四階段：深度學習（4-8 週）\n'
            '- 神經網路基礎\n'
            '- TensorFlow / PyTorch\n\n'
            '建議從 Andrew Ng 的課程開始！🚀',
        timestamp: now.subtract(const Duration(days: 3)),
        isFavorite: true,
      ),
    ]);

    // 對話 4
    final conv4 = Conversation(
      id: 'conv_mock_4',
      title: '設計模式：觀察者模式',
      createdAt: now.subtract(const Duration(days: 5)),
      updatedAt: now.subtract(const Duration(days: 5)),
    );
    conv4.messages.addAll([
      ChatMessage(
        id: 'msg_m7',
        conversationId: conv4.id,
        role: MessageRole.user,
        content: '什麼是觀察者模式？可以給一個實際例子嗎？',
        timestamp: now.subtract(const Duration(days: 5)),
      ),
      ChatMessage(
        id: 'msg_m8',
        conversationId: conv4.id,
        role: MessageRole.assistant,
        content: '## 觀察者模式 (Observer Pattern)\n\n'
            '觀察者模式定義了一種一對多的依賴關係，讓多個觀察者同時監聽一個主題。'
            '當主題狀態改變時，所有觀察者都會收到通知。\n\n'
            '**實際例子：** YouTube 訂閱\n'
            '- 頻道 = Subject（主題）\n'
            '- 訂閱者 = Observer（觀察者）\n'
            '- 發布影片 = 狀態改變 → 通知所有訂閱者\n\n'
            '這個模式在 Flutter 中非常常見，例如 `ChangeNotifier`。',
        timestamp: now.subtract(const Duration(days: 5)),
        isFavorite: true,
      ),
    ]);

    _conversations.addAll([conv1, conv2, conv3, conv4]);
  }
}
