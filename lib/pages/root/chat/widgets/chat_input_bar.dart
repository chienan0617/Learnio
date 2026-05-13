import 'package:learnio/base.dart';

class ChatInputBar extends StatefulWidget {
  final void Function(String content) onSend;
  final VoidCallback? onVoicePressed;
  final VoidCallback? onAttachPressed;
  final String? hintText;

  const ChatInputBar({
    super.key,
    required this.onSend,
    this.onVoicePressed,
    this.onAttachPressed,
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
    return Container(
      padding: EdgeInsets.only(
        left: DesignSystem.space12,
        right: DesignSystem.space12,
        top: DesignSystem.space12,
        bottom: MediaQuery.of(context).padding.bottom + DesignSystem.space16,
      ),
      decoration: BoxDecoration(
        color: bg1,
        border: Border(
          top: BorderSide(color: bg3.withOpacity(0.3), width: 0.5),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: bg2,
          borderRadius: DesignSystem.borderXL,
          border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
          boxShadow: DesignSystem.shadowSoft,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 輸入區
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 附件按鈕
                Padding(
                  padding: const EdgeInsets.only(left: DesignSystem.space4, bottom: DesignSystem.space4),
                  child: IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      widget.onAttachPressed?.call();
                    },
                    icon: Icon(
                      Icons.add_circle_outline_rounded,
                      color: tx6,
                      size: 24,
                    ),
                    splashRadius: 20,
                    padding: const EdgeInsets.all(DesignSystem.space8),
                    constraints: const BoxConstraints(),
                  ),
                ),

                // 文字輸入框
                Expanded(
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    style: tsBodyLarge.copyWith(fontSize: 15),
                    maxLines: 5,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: widget.hintText ?? '詢問任何問題...',
                      hintStyle: tsBodyLarge.copyWith(
                        color: tx6.withOpacity(0.5),
                        fontSize: 15,
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
                Padding(
                  padding: const EdgeInsets.only(right: DesignSystem.space8, bottom: DesignSystem.space8),
                  child: AnimatedSwitcher(
                    duration: DesignSystem.animFast,
                    transitionBuilder: (child, anim) {
                      return ScaleTransition(scale: anim, child: child);
                    },
                    child: _hasText
                        ? _buildSendButton()
                        : _buildVoiceButton(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
      key: const ValueKey('send'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: DesignSystem.borderL,
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: _handleSend,
        icon: const Icon(
          Icons.arrow_upward_rounded,
          color: Colors.white,
          size: 20,
        ),
        splashRadius: 20,
        padding: const EdgeInsets.all(DesignSystem.space8),
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildVoiceButton() {
    return IconButton(
      key: const ValueKey('voice'),
      onPressed: () {
        HapticFeedback.lightImpact();
        widget.onVoicePressed?.call();
      },
      icon: Icon(
        Icons.mic_none_rounded,
        color: tx6,
        size: 24,
      ),
      splashRadius: 20,
      padding: const EdgeInsets.all(DesignSystem.space8),
      constraints: const BoxConstraints(),
    );
  }
}
