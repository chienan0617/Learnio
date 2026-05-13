import 'package:learnio/base.dart';
import 'package:learnio/script/controller/chat/chat_controller.dart';
import 'package:learnio/script/controller/chat/conversation_controller.dart';
import 'package:learnio/script/controller/chat/learning_controller.dart';
import 'package:learnio/pages/root/chat/widgets/message_bubble.dart';
import 'package:learnio/pages/root/chat/widgets/chat_input_bar.dart';
import 'package:learnio/pages/root/chat/widgets/model_selector.dart';
import 'package:learnio/pages/root/chat/widgets/typing_indicator.dart';

class ChatPage extends StatefulWidget {
  final ChatController chatController;
  final ConversationController conversationController;
  final LearningController learningController;

  const ChatPage({
    super.key,
    required this.chatController,
    required this.conversationController,
    required this.learningController,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();

  ChatController get _chat => widget.chatController;
  ConversationController get _conv => widget.conversationController;

  @override
  void initState() {
    super.initState();
    _chat.onStateChanged = () {
      if (mounted) {
        setState(() {});
        _scrollToBottom();
      }
    };
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 頂部欄
        _buildTopBar(context),

        // 訊息列表
        Expanded(
          child: _chat.messages.isEmpty
              ? _buildEmptyState()
              : _buildMessageList(),
        ),

        // 輸入區
        ChatInputBar(
          onSend: (content) => _chat.sendMessage(content),
          onVoicePressed: () {
            // TODO: 語音輸入
          },
          onAttachPressed: () {
            // TODO: 附件
          },
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: bg1,
        border: Border(
          bottom: BorderSide(color: bg3.withOpacity(0.2), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // 漢堡選單
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu_rounded, color: tx1, size: 24),
          ),

          const Spacer(),

          // 模型選擇
          ModelSelector(
            chatController: _chat,
            onChanged: () => setState(() {}),
          ),

          const Spacer(),

          // 新對話
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              _conv.startNewConversation();
              setState(() {});
            },
            icon: Icon(Icons.edit_square, color: tx1, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // AI Logo
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary.withOpacity(0.8), secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 36,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '有什麼想學的嗎？',
              style: TextStyle(
                color: tx1,
                fontSize: 22,
                fontWeight: fw7,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '我是 Learnio，你的 AI 學習助手',
              style: TextStyle(
                color: tx6,
                fontSize: 14,
                fontWeight: fw4,
              ),
            ),
            const SizedBox(height: 32),

            // 建議問題
            ..._buildSuggestions(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSuggestions() {
    final suggestions = [
      ('💡', '解釋 Flutter 的 Widget 體系'),
      ('📚', '如何開始學習 Python？'),
      ('🧠', '費曼學習法是什麼？'),
      ('🔧', '什麼是設計模式？'),
    ];

    return suggestions.map((s) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            _chat.sendMessage(s.$2);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: bg2,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
            ),
            child: Row(
              children: [
                Text(s.$1, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    s.$2,
                    style: TextStyle(
                      color: tx2,
                      fontSize: 14,
                      fontWeight: fw4,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: tx6.withOpacity(0.5)),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _chat.messages.length + (_chat.isGenerating ? 1 : 0),
      itemBuilder: (context, index) {
        // 最後一個是打字指示器
        if (index == _chat.messages.length && _chat.isGenerating) {
          return const TypingIndicator();
        }

        final msg = _chat.messages[index];
        return MessageBubble(
          key: ValueKey(msg.id),
          message: msg,
          onFavoriteToggle: () {
            _chat.toggleFavorite(msg.id);
          },
          onSaveToLibrary: () {
            widget.learningController.addItem(
              title: msg.content.length > 30
                  ? '${msg.content.substring(0, 30)}...'
                  : msg.content,
              summary: msg.content,
              sourceMessageId: msg.id,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('已儲存到學習庫'),
                backgroundColor: bg3,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
