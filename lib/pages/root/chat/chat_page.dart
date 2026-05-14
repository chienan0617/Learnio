import 'package:learnio/base.dart';
import 'package:learnio/script/controller/chat/chat_controller.dart';
import 'package:learnio/script/controller/chat/conversation_controller.dart';
import 'package:learnio/script/controller/chat/learning_controller.dart';
import 'package:learnio/pages/root/chat/widgets/message_bubble.dart';
import 'package:learnio/pages/root/chat/widgets/chat_input_bar.dart';
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
    return column([
      // 頂部欄
      _buildTopBar(context),

      // 訊息列表
      expand(
        _chat.messages.isEmpty ? _buildEmptyState() : _buildMessageList(),
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: text('已選擇 ${files.length} 個檔案')));
        },
      ),
    ], ms: MainAxisSize.max);
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
      child: row([
        // 漢堡選單
        iconButton(
          icon(Icons.menu_outlined, 26),
          () {
            HapticFeedback.lightImpact();
            Scaffold.of(context).openDrawer();
          },
        ),

        expand(
          text(
            _chat.current?.title ?? 'Learnio',
            18,
            fw6,
            tx1,
            false,
            null,
            fsN,
            TextAlign.center,
            1,
            TextOverflow.ellipsis,
          ),
        ),

        // 新對話
        iconButton(
          icon(Icons.add_comment_outlined, 24),
          () {
            HapticFeedback.lightImpact();
            _conv.startNewConversation();
            setState(() {});
          },
        ),
      ]),
    );
  }

  Widget _buildEmptyState() {
    return scroll(
      padding(
        symmetric(DesignSystem.space32, 64),
        column(
          [
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
              child: icon(Icons.auto_awesome_outlined, 40, Colors.white),
            ),
            height(DesignSystem.space32),
            text(
              '有什麼想學的嗎？',
              24,
              fw8,
              tx1,
              false,
              null,
              fsN,
              TextAlign.center,
            ),
            height(DesignSystem.space12),
            text(
              '我是 Learnio，你的 AI 學習助手\n我可以幫你整理知識、回答問題或制定學習計劃',
              14,
              fw4,
              tx6,
              false,
              null,
              fsN,
              TextAlign.center,
            ),
            height(DesignSystem.space32),

            // 建議問題
            ..._buildSuggestions(),
          ],
          ca: CrossAxisAlignment.center,
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
      return padding(
        const EdgeInsets.only(bottom: DesignSystem.space12),
        inkWell(
          container(
            row([
              text(s.$1, 20),
              width(DesignSystem.space16),
              expand(
                text(
                  s.$2,
                  14,
                  fw5,
                  tx1,
                ),
              ),
              icon(
                Icons.arrow_forward_ios_rounded,
                14,
                tx6.withOpacity(0.4),
              ),
            ]),
            width: double.infinity,
            padding: symmetric(DesignSystem.space20, DesignSystem.space16),
            color: bg2,
            radius: DesignSystem.borderM,
            border: Border.all(color: bg3.withOpacity(0.4), width: 0.5),
          ),
          () {
            HapticFeedback.lightImpact();
            _chat.sendMessage(s.$2);
          },
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
                content: text(
                  '已儲存到學習庫',
                  14,
                  fw4,
                  Colors.white,
                ),
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
