import 'package:learnio/base.dart';
import 'package:learnio/script/types/chat_message.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:learnio/pages/root/chat/widgets/markdown_builders.dart';
import 'package:markdown/markdown.dart' as md;
import 'dart:ui' as ui;


class MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final bool isGenerating;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onSaveToLibrary;
  final VoidCallback? onRetry;

  const MessageBubble({
    super.key,
    required this.message,
    this.isGenerating = false,
    this.onFavoriteToggle,
    this.onSaveToLibrary,
    this.onRetry,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late AnimationController _breatheController;
  late Animation<double> _breatheAnimation;

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

    _breatheController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _breatheAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );

    if (widget.isGenerating) {
      _breatheController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(MessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isGenerating != oldWidget.isGenerating) {
      if (widget.isGenerating) {
        _breatheController.repeat(reverse: true);
      } else {
        _breatheController.stop();
        _breatheController.animateTo(0, duration: const Duration(milliseconds: 300));
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _breatheController.dispose();
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
              ClipRRect(
                borderRadius: DesignSystem.borderXL,
                child: BackdropFilter(
                  filter: !msg.isError
                      ? ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15)
                      : ui.ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: container(
                    column([
                      if (msg.images != null && msg.images!.isNotEmpty) ...[
                        _buildImageGrid(msg.images!),
                        height(DesignSystem.space8),
                      ],
                      if (msg.files != null && msg.files!.isNotEmpty) ...[
                        _buildFileList(msg.files!),
                        height(DesignSystem.space8),
                      ],
                      if (msg.links != null && msg.links!.isNotEmpty) ...[
                        _buildLinkList(msg.links!),
                        height(DesignSystem.space8),
                      ],
                      if (msg.isError)
                        _buildErrorContent()
                      else
                        MarkdownBody(
                          data: msg.content,
                          selectable: true,
                          extensionSet: md.ExtensionSet(
                            md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                            [
                              ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
                              MarkdownLatexSyntax(),
                            ],
                          ),
                          builders: {
                            'code': CodeElementBuilder(),
                            'latex': LatexElementBuilder(),
                          },
                          styleSheet: MarkdownStyleSheet(
                            p: tsBodyLarge.copyWith(
                              fontSize: 15,
                              color: tx1.withOpacity(0.95),
                            ),
                            h1: tsTitleLarge.copyWith(fontSize: 22),
                            h2: tsTitleLarge.copyWith(fontSize: 20),
                            h3: tsTitleLarge.copyWith(fontSize: 18),
                            listBullet: tsBodyLarge.copyWith(fontSize: 15, color: CommonColors.warning),
                            a: tsBodyLarge.copyWith(
                              fontSize: 15,
                              color: CommonColors.warning,
                              decoration: TextDecoration.underline,
                            ),
                            blockquoteDecoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: CommonColors.warning.withOpacity(0.5),
                                  width: 4,
                                ),
                              ),
                            ),
                            code: tsBodyMedium.copyWith(
                              backgroundColor: bg3.withOpacity(0.3),
                              fontFamily: 'monospace',
                              fontSize: 13,
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
                        : bg2.withOpacity(0.7),
                    border: Border.all(
                      color: msg.isError
                          ? Colors.red.withOpacity(0.3)
                          : bg3.withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
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
    return ScaleTransition(
      scale: _breatheAnimation,
      child: container(
        widget.message.isError
            ? icon(Icons.error_outline, 16, Colors.white)
            : logo(16, Colors.white),
        width: 32,

      height: 28,
      gradient: LinearGradient(
        colors: widget.message.isError 
            ? [Colors.redAccent, Colors.red] 
            : [primary, secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      radius: DesignSystem.borderS,
    ));
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

  Widget _buildFileList(List<String> files) {
    return column(
      files.map((fileData) {
        final parts = fileData.split(':');
        final name = parts[0];
        final ext = name.split('.').last.toUpperCase();

        return container(
          row([
            icon(Icons.insert_drive_file_outlined, 20, primary),
            width(DesignSystem.space12),
            expand(text(name, 14, fw5, tx1, false, null, fsN, TextAlign.start, 1, TextOverflow.ellipsis)),
            text(ext, 10, fw7, tx6),
          ]),
          padding: symmetric(DesignSystem.space12, DesignSystem.space8),
          margin: const EdgeInsets.only(bottom: DesignSystem.space4),
          color: bg3.withOpacity(0.3),
          radius: DesignSystem.borderS,
        );
      }).toList(),
    );
  }

  Widget _buildLinkList(List<String> links) {
    return column(
      links.map((link) {
        return inkWell(
          container(
            row([
              icon(Icons.link_outlined, 18, primary),
              width(DesignSystem.space12),
              expand(text(link, 14, fw5, primary, false, null, fsN, TextAlign.start, 1, TextOverflow.ellipsis)),
              icon(Icons.open_in_new_rounded, 14, primary),
            ]),
            padding: symmetric(DesignSystem.space12, DesignSystem.space8),
            margin: const EdgeInsets.only(bottom: DesignSystem.space4),
            color: primary.withOpacity(0.05),
            radius: DesignSystem.borderS,
            border: Border.all(color: primary.withOpacity(0.2), width: 0.5),
          ),
          () => launchUrl(Uri.parse(link)),
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
