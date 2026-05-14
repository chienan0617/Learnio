import 'package:learnio/base.dart';
import 'package:learnio/script/controller/chat/chat_controller.dart';
import 'package:learnio/script/controller/chat/conversation_controller.dart';
import 'package:learnio/script/controller/chat/command_controller.dart';
import 'package:learnio/pages/root/chat/widgets/model_selector.dart';
import 'package:file_picker/file_picker.dart';

class ChatInputBar extends StatefulWidget {
  final ChatController chatController;
  final ConversationController conversationController;
  final void Function(String content, List<String> images) onSend;
  final VoidCallback? onVoicePressed;
  final void Function(List<PlatformFile> files)? onFilesSelected;
  final String? hintText;

  const ChatInputBar({
    super.key,
    required this.chatController,
    required this.conversationController,
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
  bool _showCommands = false;
  List<PlatformFile> _selectedFiles = [];
  final List<ChatCommand> _commands = CommandController.getCommands();

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

  Future<void> _handleSend() async {
    final text = _textController.text.trim();
    if (text.isEmpty && _selectedFiles.isEmpty) return;
    
    HapticFeedback.mediumImpact();
    
    // Convert files to base64 images
    List<String> base64Images = [];
    for (var file in _selectedFiles) {
      if (file.bytes != null) {
        base64Images.add(base64Encode(file.bytes!));
      } else if (file.path != null) {
        final bytes = await File(file.path!).readAsBytes();
        base64Images.add(base64Encode(bytes));
      }
    }

    widget.onSend(text, base64Images);
    
    _textController.clear();
    setState(() {
      _selectedFiles = [];
      _showCommands = false;
    });
    _focusNode.requestFocus();
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.files);
      });
      widget.onFilesSelected?.call(result.files);
    }
  }

  @override
  Widget build(BuildContext context) {
    return container(
      column([
        // 指令選單 (位於輸入框上方)
        if (_showCommands) _buildCommandMenu(),

        container(
          column([
            if (_selectedFiles.isNotEmpty) ...[
              _buildFilePreview(),
              Divider(color: bg3.withOpacity(0.3), height: 1),
            ],

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
            ], ca: CrossAxisAlignment.end),

            Divider(color: bg3.withOpacity(0.3), height: 1),

            // 底部工具列
            padding(
              symmetric(DesignSystem.space12, DesignSystem.space8),
              row([
                // 附件按鈕
                iconButton(icon(Icons.add_circle_outline, 22, tx6), _pickFiles),
                width(DesignSystem.space4),
                
                // 指令按鈕
                iconButton(
                  icon(Icons.terminal_outlined, 22, _showCommands ? primary : tx6),
                  () => setState(() => _showCommands = !_showCommands),
                ),
                width(DesignSystem.space4),

                // 模型選擇
                ModelSelector(
                  chatController: widget.chatController,
                  onChanged: () => setState(() {}),
                ),
                
                const Spacer(),

                // 語音按鈕 / 送出按鈕
                AnimatedSwitcher(
                  duration: DesignSystem.animFast,
                  transitionBuilder: (child, anim) {
                    return ScaleTransition(scale: anim, child: child);
                  },
                  child: (_hasText || _selectedFiles.isNotEmpty) ? _buildSendButton() : _buildVoiceButton(),
                ),
              ]),
            ),
          ]),
          color: bg2,
          radius: DesignSystem.borderXL,
          border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
          shadow: DesignSystem.shadowSoft,
        ),
      ]),
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

  Widget _buildCommandMenu() {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignSystem.space8),
      padding: symmetricAll(DesignSystem.space8),
      decoration: BoxDecoration(
        color: bg2,
        borderRadius: BorderRadius.circular(DesignSystem.borderL.topLeft.x),
        border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
        boxShadow: DesignSystem.shadowSoft,
      ),
      child: column(

        _commands.map((cmd) => inkWell(
          container(
            row([
              icon(cmd.icon, 20, tx6),
              width(DesignSystem.space12),
              column([
                text(cmd.name, 15, fw6, tx1),
                text(cmd.description, 12, fw4, tx6),
              ], ca: CrossAxisAlignment.start),
            ]),
            padding: symmetric(DesignSystem.space12, DesignSystem.space8),
          ),
          () async {
            setState(() => _showCommands = false);
            await cmd.execute(context, widget.chatController, widget.conversationController);
          },
        )).toList(),
      ),
    );
  }

  Widget _buildFilePreview() {
    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: symmetric(DesignSystem.space12, DesignSystem.space8),
        itemCount: _selectedFiles.length,
        itemBuilder: (context, index) {
          final file = _selectedFiles[index];
          return padding(
            const EdgeInsets.only(right: DesignSystem.space8),
            Stack(
              children: [
                container(
                  file.bytes != null 
                    ? Image.memory(file.bytes!, fit: BoxFit.cover)
                    : (file.path != null ? Image.file(File(file.path!), fit: BoxFit.cover) : icon(Icons.insert_drive_file)),
                  width: 60,
                  height: 60,
                  radius: DesignSystem.borderS,
                  clip: Clip.antiAlias,
                ),
                positioned(
                  inkWell(
                    container(
                      icon(Icons.close, 12, Colors.white),
                      width: 20,
                      height: 20,
                      color: Colors.black54,
                      radius: BorderRadius.circular(10),
                    ),
                    () => setState(() => _selectedFiles.removeAt(index)),
                  ),
                  t: -5,
                  r: -5,
                ),
              ],
            ),
          );
        },
      ),
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
