import 'package:learnio/base.dart';
import 'package:learnio/script/controller/chat/chat_controller.dart';
import 'package:learnio/script/controller/chat/conversation_controller.dart';
import 'package:learnio/script/controller/chat/learning_controller.dart';
import 'package:learnio/pages/root/chat/widgets/message_bubble.dart';
import 'package:learnio/pages/root/chat/widgets/chat_input_bar.dart';
import 'package:learnio/pages/root/chat/widgets/typing_indicator.dart';
import 'package:learnio/script/types/chat_message.dart';

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
    final isIncognito = _chat.isIncognito;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: column([
        // 頂部欄
        _buildTopBar(context),

        // 無痕模式橫幅
        if (isIncognito)
          container(
            row([
              icon(Icons.privacy_tip_outlined, 14, Colors.white),
              width(8),
              text('已啟動無痕模式 - 訊息不會被儲存', 12, fw5, Colors.white),
            ], ma: MainAxisAlignment.center),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            color: hexColor('#2d3436'),
          ),

        // 內容區
        expand(
          stack([
            // 訊息列表
            Positioned.fill(
              child: _chat.messages.isEmpty
                  ? _buildEmptyState()
                  : _buildMessageList(),
            ),

            // 懸浮輸入區
            positioned(
              ChatInputBar(
                chatController: _chat,
                conversationController: _conv,
                onSend: (content, images, files, links) => _chat.sendMessage(
                  content,
                  images: images,
                  files: files,
                  links: links,
                ),
                onVoicePressed: () {
                  // TODO: 語音輸入
                },
                onFilesSelected: (files) {
                  // TODO: 處理選擇的文件
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: text('已選擇 ${files.length} 個檔案')),
                  );
                },
              ),
              b: 0,
              l: 0,
              r: 0,
            ),
          ]),
        ),
      ], ms: MainAxisSize.max),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final isIncognito = _chat.isIncognito;

    return container(
      row(
        [
          // 漢堡選單
          iconButton(
            icon(Icons.menu_outlined, 26, isIncognito ? tx1 : null),
            () {
              HapticFeedback.lightImpact();
              Scaffold.of(context).openDrawer();
            },
          ),

          expand(
            text(
              isIncognito ? '無痕對話' : (_chat.current?.title ?? 'Learnio'),
              18,
              fw6,
              isIncognito ? tx1 : tx1,
              false,
              null,
              fsN,
              TextAlign.center,
              1,
              TextOverflow.ellipsis,
            ),
          ),

          // 無痕模式切換
          iconButton(
            icon(
              isIncognito ? Icons.privacy_tip : Icons.privacy_tip_outlined,
              24,
              isIncognito ? primary : tx6,
            ),
            () {
              HapticFeedback.mediumImpact();
              _conv.setIncognito(!isIncognito);
              setState(() {});
            },
          ),

          // 新對話 (非無痕模式才顯示，或在無痕模式下作為重置)
          iconButton(
            icon(Icons.add_comment_outlined, 24, isIncognito ? tx1 : null),
            () {
              HapticFeedback.lightImpact();
              _conv.startNewConversation();
              setState(() {});
            },
          ),
        ],
        ma: maC,
        ca: caC,
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + DesignSystem.space8,
        left: DesignSystem.space12,
        right: DesignSystem.space12,
        bottom: DesignSystem.space8,
      ),
      color: isIncognito ? bg2 : Colors.transparent,
      border: Border(
        bottom: BorderSide(
          color: isIncognito ? bg3 : bg3.withOpacity(0.2),
          width: 0.5,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return scroll(
      padding(
        symmetric(DesignSystem.space32, 32),
        column([
          height(MediaQuery.of(context).size.height * 0.1),
          // AI Logo
          container(
            logo(64),
            width: 80,
            height: 80,
            radius: DesignSystem.borderXL,
            shadow: [
              BoxShadow(
                color: primary.withOpacity(0.15),
                blurRadius: 40,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          height(DesignSystem.space32),
          text('今天想學點什麼？', 28, fw8, tx1, false, null, fsN, TextAlign.center),
          height(DesignSystem.space12),
          text(
            '我是 Learnio，你的專屬 AI 學習助手。',
            15,
            fw5,
            tx6,
            false,
            null,
            fsN,
            TextAlign.center,
          ),
          height(48),

          // 建議問題區塊
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: _buildSuggestions(),
          ),
        ], ca: CrossAxisAlignment.center),
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
      return inkWell(
        container(
          row([
            text(s.$1, 20),
            width(DesignSystem.space12),
            expand(text(s.$2, 14, fw5, tx1)),
          ]),
          width: MediaQuery.of(context).size.width * 0.4,
          padding: symmetric(DesignSystem.space16, DesignSystem.space16),
          color: bg2.withOpacity(0.6),
          radius: DesignSystem.borderL,
          border: Border.all(color: bg3.withOpacity(0.3), width: 0.5),
        ),
        () {
          HapticFeedback.lightImpact();
          _chat.sendMessage(s.$2);
        },
      );
    }).toList();
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(
        top: DesignSystem.space8,
        bottom: DesignSystem.space16,
      ),
      itemCount: _chat.messages.length + (_chat.isThinking ? 1 : 0) + 1,
      itemBuilder: (context, index) {
        // 最後一個是空間補足，確保最後一條訊息不被輸入框遮擋
        if (index == _chat.messages.length + (_chat.isThinking ? 1 : 0)) {
          return const SizedBox(height: 160);
        }

        // 最後一個是打字指示器 (僅在思考中顯示)
        if (index == _chat.messages.length && _chat.isThinking) {
          return const TypingIndicator();
        }

        final msg = _chat.messages[index];
        if (msg.role == MessageRole.assistant &&
            msg.content.isEmpty &&
            _chat.isThinking) {
          return const SizedBox.shrink();
        }

        return MessageBubble(
          key: ValueKey(msg.id),
          message: msg,
          isGenerating:
              index == _chat.messages.length - 1 &&
              _chat.isGenerating &&
              msg.role == MessageRole.assistant,
          onFavoriteToggle: () {
            _chat.toggleFavorite(msg.id);
          },
          onRetry: () {
            _chat.retryMessage(msg.id);
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
                content: text('已儲存到學習庫', 14, fw4, Colors.white),
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
