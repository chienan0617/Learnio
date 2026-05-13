import 'package:learnio/base.dart';
import 'package:learnio/script/types/chat_message.dart';

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
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
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
            left: isUser ? 48 : 16,
            right: isUser ? 16 : 48,
            top: 6,
            bottom: 6,
          ),
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // 角色標籤
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isUser) ...[
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primary, secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Learnio',
                        style: TextStyle(
                          color: tx6,
                          fontSize: 12,
                          fontWeight: fw6,
                        ),
                      ),
                    ],
                    if (isUser) ...[
                      Text(
                        '你',
                        style: TextStyle(
                          color: tx6,
                          fontSize: 12,
                          fontWeight: fw6,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // 訊息氣泡
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isUser ? primary.withOpacity(0.15) : bg2,
                  borderRadius: BorderRadius.circular(16).copyWith(
                    topLeft: isUser ? null : const Radius.circular(4),
                    topRight: isUser ? const Radius.circular(4) : null,
                  ),
                  border: Border.all(
                    color: isUser
                        ? primary.withOpacity(0.2)
                        : bg3.withOpacity(0.5),
                    width: 0.5,
                  ),
                ),
                child: SelectableText(
                  msg.content,
                  style: TextStyle(
                    color: tx1,
                    fontSize: 14.5,
                    fontWeight: fw4,
                    height: 1.6,
                    letterSpacing: 0.1,
                  ),
                ),
              ),

              // 操作按鈕列 (僅 AI 訊息)
              if (!isUser)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
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
                      const SizedBox(width: 2),
                      _actionButton(
                        icon: Icons.library_add_outlined,
                        color: tx6,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          widget.onSaveToLibrary?.call();
                        },
                      ),
                      const SizedBox(width: 2),
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

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
