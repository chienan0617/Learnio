import 'package:learnio/base.dart';
import 'package:learnio/script/types/chat_message.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onSaveToLibrary;
  final VoidCallback? onRetry;

  const MessageBubble({
    super.key,
    required this.message,
    this.onFavoriteToggle,
    this.onSaveToLibrary,
    this.onRetry,
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
        child: padding(
          EdgeInsets.only(
            left: isUser ? DesignSystem.space32 : DesignSystem.space12,
            right: isUser ? DesignSystem.space12 : DesignSystem.space32,
            top: DesignSystem.space8,
            bottom: DesignSystem.space8,
          ),
          column(
            [
              // 角色標籤 與 頭像
              padding(
                const EdgeInsets.only(
                    bottom: DesignSystem.space8,
                    left: DesignSystem.space4,
                    right: DesignSystem.space4),
                row(
                  [
                    if (!isUser) ...[
                      _buildAvatar(),
                      width(DesignSystem.space8),
                      text('Learnio', 12, fw7, tx6),
                    ],
                    if (isUser) ...[
                      text('你', 12, fw7, tx6),
                      width(DesignSystem.space8),
                      _buildUserAvatar(),
                    ],
                  ],
                ),
              ),

              // 訊息氣泡
              container(
                column([
                  if (msg.images != null && msg.images!.isNotEmpty) ...[
                    _buildImageGrid(msg.images!),
                    height(DesignSystem.space8),
                  ],
                  if (msg.isError)
                    _buildErrorContent()
                  else
                    MarkdownBody(
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
                ]),
                width: MediaQuery.of(context).size.width * 0.85,
                padding: symmetric(DesignSystem.space16, DesignSystem.space12),
                color: msg.isError 
                    ? Colors.red.withOpacity(0.05) 
                    : (isUser ? primary.withOpacity(0.08) : bg2),
                radius: BorderRadius.only(
                  topLeft: isUser ? DesignSystem.borderL.topLeft : Radius.zero,
                  topRight: isUser ? Radius.zero : DesignSystem.borderL.topRight,
                  bottomLeft: DesignSystem.borderL.bottomLeft,
                  bottomRight: DesignSystem.borderL.bottomRight,
                ),
                border: Border.all(
                  color: msg.isError 
                      ? Colors.red.withOpacity(0.3) 
                      : (isUser ? primary.withOpacity(0.15) : bg3.withOpacity(0.4)),
                  width: 0.5,
                ),
              ),

              // 操作按鈕列 (僅 AI 訊息且非錯誤)
              if (!isUser && !msg.isError)
                padding(
                  const EdgeInsets.only(top: DesignSystem.space4),
                  row([
                    _actionButton(
                      iconData: msg.isFavorite
                          ? Icons.bookmark_outlined
                          : Icons.bookmark_border_outlined,
                      color: msg.isFavorite ? primary : tx6,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        widget.onFavoriteToggle?.call();
                      },
                    ),
                    _actionButton(
                      iconData: Icons.library_add_outlined,
                      color: tx6,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        widget.onSaveToLibrary?.call();
                      },
                    ),
                    _actionButton(
                      iconData: Icons.content_copy_outlined,
                      color: tx6,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Clipboard.setData(ClipboardData(text: msg.content));
                      },
                    ),
                  ]),
                ),
            ],
            ca: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return container(
      icon(widget.message.isError ? Icons.error_outline : Icons.auto_awesome, 16, Colors.white),
      width: 28,
      height: 28,
      gradient: LinearGradient(
        colors: widget.message.isError 
            ? [Colors.redAccent, Colors.red] 
            : [primary, secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      radius: DesignSystem.borderS,
    );
  }

  Widget _buildErrorContent() {
    return column([
      row([
        icon(Icons.warning_amber_rounded, 20, Colors.redAccent),
        width(DesignSystem.space8),
        expand(
          text(
            '連線錯誤',
            16,
            fw7,
            Colors.redAccent,
          ),
        ),
      ]),
      height(DesignSystem.space8),
      text(
        widget.message.content,
        14,
        fw4,
        tx1.withOpacity(0.8),
      ),
      height(DesignSystem.space16),
      inkWell(
        container(
          row([
            icon(Icons.refresh_rounded, 16, Colors.white),
            width(DesignSystem.space8),
            text('重新嘗試', 14, fw6, Colors.white),
          ], ma: MainAxisAlignment.center),
          padding: symmetric(DesignSystem.space12, DesignSystem.space8),
          color: Colors.redAccent,
          radius: DesignSystem.borderS,
        ),
        () {
          HapticFeedback.mediumImpact();
          widget.onRetry?.call();
        },
      ),
    ], ca: CrossAxisAlignment.start);
  }

  Widget _buildUserAvatar() {
    return container(
      icon(Icons.person_rounded, 16, tx6),
      width: 28,
      height: 28,
      color: bg2,
      radius: DesignSystem.borderS,
      border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
    );
  }

  Widget _buildImageGrid(List<String> images) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: images.map((img) {
        return container(
          Image.memory(
            base64Decode(img),
            fit: BoxFit.cover,
          ),
          width: 150,
          height: 150,
          radius: DesignSystem.borderS,
          clip: Clip.antiAlias,
        );
      }).toList(),
    );
  }

  Widget _actionButton({
    required IconData iconData,
    required Color color,
    required VoidCallback onTap,
  }) {
    return inkWell(
      padding(
        symmetricAll(DesignSystem.space8),
        icon(iconData, 16, color),
      ),
      onTap,
    );
  }
}
