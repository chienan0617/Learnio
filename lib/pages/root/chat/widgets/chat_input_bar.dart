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
        left: 12,
        right: 12,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
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
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
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
                  padding: const EdgeInsets.only(left: 4, bottom: 4),
                  child: IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      widget.onAttachPressed?.call();
                    },
                    icon: Icon(
                      Icons.add_circle_outline_rounded,
                      color: tx6,
                      size: 22,
                    ),
                    splashRadius: 20,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),

                // 文字輸入框
                Expanded(
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    style: TextStyle(
                      color: tx1,
                      fontSize: 15,
                      fontWeight: fw4,
                    ),
                    maxLines: 5,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: widget.hintText ?? '詢問任何問題...',
                      hintStyle: TextStyle(
                        color: tx6.withOpacity(0.6),
                        fontSize: 15,
                        fontWeight: fw4,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 12,
                      ),
                    ),
                    cursorColor: primary,
                  ),
                ),

                // 語音按鈕 / 送出按鈕
                Padding(
                  padding: const EdgeInsets.only(right: 4, bottom: 4),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
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
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        onPressed: _handleSend,
        icon: const Icon(
          Icons.arrow_upward_rounded,
          color: Colors.white,
          size: 20,
        ),
        splashRadius: 20,
        padding: const EdgeInsets.all(8),
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
        size: 22,
      ),
      splashRadius: 20,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(),
    );
  }
}
