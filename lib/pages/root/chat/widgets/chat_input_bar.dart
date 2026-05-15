import 'package:learnio/base.dart';
import 'package:learnio/script/controller/chat/chat_controller.dart';
import 'package:learnio/script/controller/chat/conversation_controller.dart';
import 'package:learnio/script/controller/chat/command_controller.dart';
import 'package:learnio/pages/root/chat/widgets/model_selector.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class ChatInputBar extends StatefulWidget {
  final ChatController chatController;
  final ConversationController conversationController;
  final void Function(
    String content,
    List<String> images,
    List<String> files,
    List<String> links,
  )
  onSend;
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
  List<String> _selectedLinks = [];
  final ImagePicker _picker = ImagePicker();
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
    if (text.isEmpty && _selectedFiles.isEmpty && _selectedLinks.isEmpty) {
      return;
    }


    HapticFeedback.mediumImpact();

    // Separate images from other files
    List<String> images = [];
    List<String> files = [];

    for (var file in _selectedFiles) {
      final isImage = [
        'jpg',
        'jpeg',
        'png',
        'gif',
        'webp',
      ].contains(file.extension?.toLowerCase());

      String base64Content = '';
      if (file.bytes != null) {
        base64Content = base64Encode(file.bytes!);
      } else if (!kIsWeb && file.path != null) {
        final bytes = await File(file.path!).readAsBytes();
        base64Content = base64Encode(bytes);
      }

      if (isImage) {
        images.add(base64Content);
      } else {
        // For non-images, we might just send the name or metadata for now
        // But the AI backend expects images. We'll send files separately.
        files.add("${file.name}:$base64Content");
      }
    }

    widget.onSend(text, images, files, _selectedLinks);

    _textController.clear();
    setState(() {
      _selectedFiles = [];
      _selectedLinks = [];
      _showCommands = false;
    });
    _focusNode.requestFocus();
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.pickFiles(
      type: FileType.any,
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

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() {
        _selectedFiles.add(
          PlatformFile(
            name: photo.name,
            size: bytes.length,
            bytes: bytes,
            path: kIsWeb ? null : photo.path,
          ),
        );
      });
    }
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => container(
        column([
          padding(symmetricAll(DesignSystem.space16), text('新增附件', 18, fw7)),
          _attachmentOption(Icons.camera_alt_outlined, '拍攝照片', _takePhoto),
          _attachmentOption(Icons.image_outlined, '從相簿選擇', () async {
            final result = await FilePicker.pickFiles(
              type: FileType.image,
              allowMultiple: true,
              withData: true,
            );
            if (result != null) {
              setState(() => _selectedFiles.addAll(result.files));
            }
          }),
          _attachmentOption(
            Icons.insert_drive_file_outlined,
            '傳送檔案',
            _pickFiles,
          ),
          _attachmentOption(Icons.link_outlined, '添加連結', _addLinkDialog),
          height(DesignSystem.space24),
        ]),
        color: bg1,
        radius: const BorderRadius.vertical(
          top: Radius.circular(DesignSystem.radiusXL),
        ),
      ),
    );
  }

  Widget _attachmentOption(
    IconData iconData,
    String label,
    VoidCallback onTap,
  ) {
    return inkWell(
      padding(
        symmetric(DesignSystem.space20, DesignSystem.space16),
        row([
          icon(iconData, 24, tx6),
          width(DesignSystem.space16),
          text(label, 16, fw5, tx1),
        ]),
      ),
      () {
        popPage(context);
        onTap();
      },
    );
  }

  void _addLinkDialog() {
    final linkController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bg2,
        title: text('添加連結', 18, fw7),
        content: TextField(
          controller: linkController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '輸入網址 (http://...)',
            hintStyle: tsBodyMedium.copyWith(color: tx6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => popPage(context),
            child: text('取消', 14, fw5, tx6),
          ),
          TextButton(
            onPressed: () {
              if (linkController.text.isNotEmpty) {
                setState(() => _selectedLinks.add(linkController.text.trim()));
                popPage(context);
              }
            },
            child: text('添加', 14, fw7, primary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return container(
      column([
        // 指令選單 (位於輸入框上方)
        if (_showCommands) _buildCommandMenu(),

        container(
          column([
            if (_selectedFiles.isNotEmpty || _selectedLinks.isNotEmpty) ...[
              padding(
                symmetricH(DesignSystem.space12),
                column([
                  if (_selectedFiles.isNotEmpty)
                    scroll(
                      row(
                        _selectedFiles.map((file) => _buildFilePreview(file)).toList(),
                        ma: MainAxisAlignment.start,
                      ),
                      const BouncingScrollPhysics(),
                    ),
                  if (_selectedLinks.isNotEmpty)
                    padding(
                      const EdgeInsets.only(top: DesignSystem.space8),
                      column(
                        _selectedLinks.map((link) => _buildLinkPreview(link)).toList(),
                      ),
                    ),
                ]),
              ),
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
                iconButton(
                  icon(Icons.add_circle_outline, 24, tx6),
                  _showAttachmentMenu,
                ),
                width(DesignSystem.space4),

                // 指令按鈕
                iconButton(
                  icon(
                    Icons.terminal_outlined,
                    22,
                    _showCommands ? primary : tx6,
                  ),
                  () => setState(() => _showCommands = !_showCommands),
                ),
                width(DesignSystem.space4),

                // 模型選擇
                ModelSelector(
                  chatController: widget.chatController,
                  onChanged: () => setState(() {}),
                ),

                const Spacer(),

                // 語音按鈕 / 送出按鈕 / 終止按鈕
                AnimatedSwitcher(
                  duration: DesignSystem.animFast,
                  transitionBuilder: (child, anim) {
                    return ScaleTransition(scale: anim, child: child);
                  },
                  child: widget.chatController.isGenerating
                      ? _buildStopButton()
                      : (_hasText || _selectedFiles.isNotEmpty)
                          ? _buildSendButton()
                          : _buildVoiceButton(),
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
        _commands
            .map(
              (cmd) => inkWell(
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
                  await cmd.execute(
                    context,
                    widget.chatController,
                    widget.conversationController,
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildFilePreview(PlatformFile file) {
    final isImage = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp',
    ].contains(file.extension?.toLowerCase());

    return container(
      stack([
        if (isImage)
          ClipRRect(
            borderRadius: DesignSystem.borderM,
            child: kIsWeb
                ? Image.memory(
                    file.bytes!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(file.path!),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
          )
        else
          container(
            center(
              column([
                icon(Icons.insert_drive_file, 24, tx6),
                height(4),
                text(
                  file.extension?.toUpperCase() ?? 'FILE',
                  10,
                  fw7,
                  tx6,
                  false,
                  null,
                  fsN,
                  TextAlign.center,
                  1,
                  TextOverflow.ellipsis,
                ),
              ]),
            ),
            width: 60,
            height: 60,
            color: bg3,
            radius: DesignSystem.borderM,
          ),
        positioned(
          inkWell(
            container(
              icon(Icons.close, 12, Colors.white),
              color: Colors.black54,
              shape: BoxShape.circle,
              padding: symmetricAll(2),
            ),
            () => setState(() => _selectedFiles.remove(file)),
          ),
          r: -2,
          t: -2,
        ),
      ]),
      margin: const EdgeInsets.only(right: DesignSystem.space8),
    );
  }

  Widget _buildLinkPreview(String link) {
    return container(
      row([
        icon(Icons.link, 16, tx6),
        width(8),
        expand(
          text(
            link,
            14,
            fw5,
            tx1,
            false,
            null,
            fsN,
            TextAlign.start,
            1,
            TextOverflow.ellipsis,
          ),
        ),
        inkWell(
          icon(Icons.close, 16, tx6),
          () => setState(() => _selectedLinks.remove(link)),
        ),
      ]),
      padding: symmetric(DesignSystem.space12, DesignSystem.space8),
      margin: const EdgeInsets.only(bottom: DesignSystem.space4),
      color: bg3,
      radius: DesignSystem.borderM,
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

  Widget _buildStopButton() {
    return container(
      iconButton(
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        () => widget.chatController.stopGeneration(),
      ),
      key: const ValueKey('stop'),
      color: tx1,
      radius: DesignSystem.borderL,
      shadow: [
        BoxShadow(
          color: tx1.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildVoiceButton() {
    return iconButton(
      icon(Icons.mic_outlined, 24, tx6),
      () {
        HapticFeedback.lightImpact();
        widget.onVoicePressed?.call();
      },
      key: const ValueKey('voice'),
    );
  }
}
