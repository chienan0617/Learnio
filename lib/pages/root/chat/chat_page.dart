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
          duration: DesignSystem.animNormal,
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
          chatController: _chat,
          onSend: (content) => _chat.sendMessage(content),
          onVoicePressed: () {
            // TODO: 語音輸入
          },
          onFilesSelected: (files) {
            // TODO: 處理選擇的文件
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('已選擇 ${files.length} 個檔案')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + DesignSystem.space8,
        left: DesignSystem.space12,
        right: DesignSystem.space12,
        bottom: DesignSystem.space8,
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
            icon: Icon(Icons.menu_rounded, color: tx1, size: 26),
          ),

          const Spacer(),

          // 新對話
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              _conv.startNewConversation();
              setState(() {});
            },
            icon: Icon(Icons.edit_square, color: tx1, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: DesignSystem.space32, vertical: 64),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // AI Logo
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary, secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: DesignSystem.borderXL,
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.25),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: DesignSystem.space32),
            Text(
              '有什麼想學的嗎？',
              style: tsDisplay.copyWith(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignSystem.space12),
            Text(
              '我是 Learnio，你的 AI 學習助手\n我可以幫你整理知識、回答問題或制定學習計劃',
              style: tsBodyMedium.copyWith(color: tx6),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignSystem.space32),

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
        padding: const EdgeInsets.only(bottom: DesignSystem.space12),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            _chat.sendMessage(s.$2);
          },
          borderRadius: DesignSystem.borderM,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: DesignSystem.space20, vertical: DesignSystem.space16),
            decoration: BoxDecoration(
              color: bg2,
              borderRadius: DesignSystem.borderM,
              border: Border.all(color: bg3.withOpacity(0.4), width: 0.5),
            ),
            child: Row(
              children: [
                Text(s.$1, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: DesignSystem.space16),
                Expanded(
                  child: Text(
                    s.$2,
                    style: tsBodyMedium.copyWith(color: tx1, fontWeight: fw5),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: tx6.withOpacity(0.4)),
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
      padding: const EdgeInsets.symmetric(vertical: DesignSystem.space8),
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
                content: Text('已儲存到學習庫', style: tsBodyMedium.copyWith(color: Colors.white)),
                backgroundColor: bg4,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: DesignSystem.borderM,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
