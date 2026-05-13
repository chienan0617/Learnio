import 'package:learnio/base.dart';
import 'package:learnio/script/types/chat_message.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onSaveToLibrary;

  const MessageBubble({
    super.key,
    required this.message,
    this.onFavoriteToggle,
    this.onSaveToLibrary,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: DesignSystem.animNormal,
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final msg = widget.message;
    final isUser = msg.isUser;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: EdgeInsets.only(
            left: isUser ? DesignSystem.space32 : DesignSystem.space12,
            right: isUser ? DesignSystem.space12 : DesignSystem.space32,
            top: DesignSystem.space8,
            bottom: DesignSystem.space8,
          ),
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // 角色標籤 與 頭像
              Padding(
                padding: const EdgeInsets.only(
                    bottom: DesignSystem.space8,
                    left: DesignSystem.space4,
                    right: DesignSystem.space4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isUser) ...[
                      _buildAvatar(),
                      const SizedBox(width: DesignSystem.space8),
                      Text('Learnio', style: tsCaption.copyWith(fontWeight: fw7)),
                    ],
                    if (isUser) ...[
                      Text('你', style: tsCaption.copyWith(fontWeight: fw7)),
                      const SizedBox(width: DesignSystem.space8),
                      _buildUserAvatar(),
                    ],
                  ],
                ),
              ),

              // 訊息氣泡
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.85,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignSystem.space16,
                  vertical: DesignSystem.space12,
                ),
                decoration: BoxDecoration(
                  color: isUser ? primary.withOpacity(0.08) : bg2,
                  borderRadius: BorderRadius.only(
                    topLeft: isUser ? DesignSystem.borderL.topLeft : Radius.zero,
                    topRight: isUser ? Radius.zero : DesignSystem.borderL.topRight,
                    bottomLeft: DesignSystem.borderL.bottomLeft,
                    bottomRight: DesignSystem.borderL.bottomRight,
                  ),
                  border: Border.all(
                    color: isUser
                        ? primary.withOpacity(0.15)
                        : bg3.withOpacity(0.4),
                    width: 0.5,
                  ),
                ),
                child: MarkdownBody(
                  data: msg.content,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: tsBodyLarge.copyWith(
                      fontSize: 17,
                      color: isUser ? tx1 : tx1.withOpacity(0.95),
                    ),
                    h1: tsTitleLarge.copyWith(fontSize: 24),
                    h2: tsTitleLarge.copyWith(fontSize: 22),
                    h3: tsTitleLarge.copyWith(fontSize: 20),
                    listBullet: tsBodyLarge.copyWith(fontSize: 17, color: primary),
                    code: tsBodyMedium.copyWith(
                      backgroundColor: bg3.withOpacity(0.3),
                      fontFamily: 'monospace',
                    ),
                    codeblockDecoration: BoxDecoration(
                      color: bg3.withOpacity(0.2),
                      borderRadius: DesignSystem.borderS,
                    ),
                  ),
                ),
              ),

              // 操作按鈕列 (僅 AI 訊息)
              if (!isUser)
                Padding(
                  padding: const EdgeInsets.only(top: DesignSystem.space4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _actionButton(
                        icon: msg.isFavorite
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: msg.isFavorite ? primary : tx6,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          widget.onFavoriteToggle?.call();
                        },
                      ),
                      _actionButton(
                        icon: Icons.library_add_outlined,
                        color: tx6,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          widget.onSaveToLibrary?.call();
                        },
                      ),
                      _actionButton(
                        icon: Icons.content_copy_rounded,
                        color: tx6,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Clipboard.setData(ClipboardData(text: msg.content));
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: DesignSystem.borderS,
      ),
      child: const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: bg2,
        borderRadius: DesignSystem.borderS,
        border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
      ),
      child: Icon(Icons.person_rounded, size: 16, color: tx6),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: DesignSystem.borderS,
      child: Padding(
        padding: const EdgeInsets.all(DesignSystem.space8),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
