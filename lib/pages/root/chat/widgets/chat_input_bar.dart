import 'package:learnio/base.dart';
import 'package:learnio/script/controller/chat/chat_controller.dart';
import 'package:learnio/pages/root/chat/widgets/model_selector.dart';
import 'package:file_picker/file_picker.dart';

class ChatInputBar extends StatefulWidget {
  final ChatController chatController;
  final void Function(String content) onSend;
  final VoidCallback? onVoicePressed;
  final void Function(List<PlatformFile> files)? onFilesSelected;
  final String? hintText;

  const ChatInputBar({
    super.key,
    required this.chatController,
    required this.onSend,
    this.onVoicePressed,
    this.onFilesSelected,
    this.hintText,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      final hasText = _textController.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.mediumImpact();
    widget.onSend(text);
    _textController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return container(
      container(
        column([
          // 模型選擇與附件預覽 (頂部工具列)
          padding(
            symmetric(DesignSystem.space12, DesignSystem.space8),
            row([
              ModelSelector(
                chatController: widget.chatController,
                onChanged: () => setState(() {}),
              ),
              const Spacer(),
              // 附件按鈕
              iconButton(icon(Icons.add_circle_outline, 22, tx6), () async {
                HapticFeedback.lightImpact();
              }),
            ]),
          ),

          Divider(color: bg3.withOpacity(0.3), height: 1),

          // 輸入區
          row([
            width(DesignSystem.space12),
            // 文字輸入框
            expand(
              TextField(
                controller: _textController,
                focusNode: _focusNode,
                style: tsBodyLarge.copyWith(fontSize: 17),
                maxLines: 5,
                minLines: 1,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: widget.hintText ?? '詢問任何問題...',
                  hintStyle: tsBodyLarge.copyWith(
                    color: tx6.withOpacity(0.5),
                    fontSize: 17,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: DesignSystem.space8,
                    vertical: DesignSystem.space12,
                  ),
                ),
                cursorColor: primary,
              ),
            ),

            // 語音按鈕 / 送出按鈕
            padding(
              const EdgeInsets.only(
                right: DesignSystem.space8,
                bottom: DesignSystem.space8,
              ),
              AnimatedSwitcher(
                duration: DesignSystem.animFast,
                transitionBuilder: (child, anim) {
                  return ScaleTransition(scale: anim, child: child);
                },
                child: _hasText ? _buildSendButton() : _buildVoiceButton(),
              ),
            ),
          ], ca: CrossAxisAlignment.end),
        ]),
        color: bg2,
        radius: DesignSystem.borderXL,
        border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
        shadow: DesignSystem.shadowSoft,
      ),
      padding: EdgeInsets.only(
        left: DesignSystem.space12,
        right: DesignSystem.space12,
        top: DesignSystem.space12,
        bottom: MediaQuery.of(context).padding.bottom + DesignSystem.space16,
      ),
      color: bg1,
      border: Border(top: BorderSide(color: bg3.withOpacity(0.3), width: 0.5)),
    );
  }

  Widget _buildSendButton() {
    return container(
      iconButton(
        icon(Icons.arrow_upward_outlined, 20, Colors.white),
        _handleSend,
      ),
      key: const ValueKey('send'),
      gradient: LinearGradient(
        colors: [primary, secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      radius: DesignSystem.borderL,
      shadow: [
        BoxShadow(
          color: primary.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildVoiceButton() {
    return iconButton(icon(Icons.mic_outlined, 24, tx6), () {
      HapticFeedback.lightImpact();
      widget.onVoicePressed?.call();
    });
  }
}
