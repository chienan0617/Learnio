import 'package:learnio/base.dart';
import 'package:learnio/script/controller/chat/chat_controller.dart';
import 'package:learnio/script/controller/chat/conversation_controller.dart';
import 'package:learnio/script/controller/chat/command_controller.dart';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;

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
  bool _showModels = false;
  bool _showAttachments = false;
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

  void _addLinkDialog() {
    final linkController = TextEditingController();
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ClipRRect(
          borderRadius: DesignSystem.borderXL,
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: container(
              column([
                text('添加連結', 18, fw7),
                height(DesignSystem.space16),
                TextField(
                  controller: linkController,
                  autofocus: true,
                  style: tsBodyMedium.copyWith(color: tx1),
                  decoration: InputDecoration(
                    hintText: '輸入網址 (http://...)',
                    hintStyle: tsBodyMedium.copyWith(color: tx6),
                    border: OutlineInputBorder(
                      borderRadius: DesignSystem.borderM,
                      borderSide: BorderSide(color: bg3.withOpacity(0.5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: DesignSystem.borderM,
                      borderSide: BorderSide(color: bg3.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: DesignSystem.borderM,
                      borderSide: BorderSide(color: primary),
                    ),
                    filled: true,
                    fillColor: bg3.withOpacity(0.2),
                  ),
                ),
                height(DesignSystem.space24),
                row([
                  const Spacer(),
                  TextButton(
                    onPressed: () => popPage(context),
                    child: text('取消', 14, fw5, tx6),
                  ),
                  width(DesignSystem.space8),
                  TextButton(
                    onPressed: () {
                      if (linkController.text.isNotEmpty) {
                        setState(
                          () => _selectedLinks.add(linkController.text.trim()),
                        );
                        popPage(context);
                      }
                    },
                    child: text('添加', 14, fw7, primary),
                  ),
                ]),
              ]),
              padding: symmetricAll(DesignSystem.space24),
              color: bg2.withOpacity(0.85),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return container(
      column([
        // 選單內容 (指令/模型/附件)
        if (_showCommands) _buildCommandMenu(),
        if (_showModels) _buildModelMenu(),
        if (_showAttachments) _buildAttachmentMenu(),

        // 主要輸入框
        ClipRRect(
          borderRadius: DesignSystem.borderXL,
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: container(
              column([
                if (_selectedFiles.isNotEmpty || _selectedLinks.isNotEmpty) ...[
                  padding(
                    symmetricH(DesignSystem.space12),
                    column([
                      if (_selectedFiles.isNotEmpty)
                        scroll(
                          row(
                            _selectedFiles
                                .map((file) => _buildFilePreview(file))
                                .toList(),
                            ma: MainAxisAlignment.start,
                          ),
                          const BouncingScrollPhysics(),
                        ),
                      if (_selectedLinks.isNotEmpty)
                        padding(
                          const EdgeInsets.only(top: DesignSystem.space8),
                          column(
                            _selectedLinks
                                .map((link) => _buildLinkPreview(link))
                                .toList(),
                          ),
                        ),
                    ]),
                  ),
                  Divider(color: bg3.withOpacity(0.2), height: 1),
                ],

                // 輸入區
                row([
                  width(DesignSystem.space12),
                  expand(
                    TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      style: tsBodyLarge.copyWith(fontSize: 16),
                      maxLines: 5,
                      minLines: 1,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: widget.hintText ?? '詢問任何問題...',
                        hintStyle: tsBodyLarge.copyWith(
                          color: tx6.withOpacity(0.5),
                          fontSize: 16,
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

                Divider(color: bg3.withOpacity(0.2), height: 1),

                // 底部工具列
                padding(
                  const EdgeInsets.symmetric(
                    horizontal: DesignSystem.space8,
                    vertical: DesignSystem.space6,
                  ),
                  row(
                    [
                      // 附件按鈕
                      iconButton(
                        icon(
                          Icons.add_circle_outline,
                          24,
                          _showAttachments ? primary : tx6,
                        ),
                        () => setState(() {
                          _showAttachments = !_showAttachments;
                          _showCommands = false;
                          _showModels = false;
                        }),
                      ),
                      width(DesignSystem.space4),

                      // 指令按鈕
                      iconButton(
                        icon(
                          Icons.terminal_outlined,
                          22,
                          _showCommands ? primary : tx6,
                        ),
                        () => setState(() {
                          _showCommands = !_showCommands;
                          _showAttachments = false;
                          _showModels = false;
                        }),
                      ),
                      width(DesignSystem.space4),

                      // 模型選擇按鈕
                      inkWell(
                        container(
                          row([
                            icon(
                              Icons.auto_awesome,
                              20,
                              _showModels ? primary : tx6,
                            ),
                            width(DesignSystem.space4),
                            text(
                              widget.chatController.selectedModel,
                              14,
                              fw6,
                              _showModels ? primary : tx2,
                            ),
                            width(DesignSystem.space2),
                            icon(
                              Icons.keyboard_arrow_down_rounded,
                              18,
                              _showModels ? primary : tx6,
                            ),
                          ], ca: CrossAxisAlignment.center),
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignSystem.space8,
                            vertical: DesignSystem.space8,
                          ),
                          color: _showModels
                              ? primary.withOpacity(0.1)
                              : Colors.transparent,
                          radius: DesignSystem.borderM,
                        ),
                        () => setState(() {
                          _showModels = !_showModels;
                          _showCommands = false;
                          _showAttachments = false;
                        }),
                        radius: DesignSystem.borderM,
                      ),

                      const Spacer(),

                      // 語音 / 送出 / 停止
                      AnimatedSwitcher(
                        duration: DesignSystem.animFast,
                        child: widget.chatController.isGenerating
                            ? _buildStopButton()
                            : (_hasText || _selectedFiles.isNotEmpty)
                            ? _buildSendButton()
                            : _buildVoiceButton(),
                      ),
                    ],
                    ma: maC,
                    ca: caC,
                  ),
                ),
              ]),
              color: bg2.withOpacity(0.7),
              border: Border.all(color: bg3.withOpacity(0.3), width: 0.5),
            ),
          ),
        ),
      ]),
      padding: EdgeInsets.only(
        left: DesignSystem.space16,
        right: DesignSystem.space16,
        top: DesignSystem.space12,
        bottom: MediaQuery.of(context).padding.bottom + DesignSystem.space16,
      ),
      color: Colors.transparent, // 移除原本的滿版背景
    );
  }

  Widget _buildModelMenu() {
    return _buildFloatingMenu(
      widget.chatController.availableModels.map((model) {
        final isSelected = model.name == widget.chatController.selectedModel;
        return _buildMenuItem(
          iconData: Icons.auto_awesome_outlined,
          title: model.name,
          subtitle: model.desc,
          isSelected: isSelected,
          onTap: () {
            widget.chatController.selectModel(model);
            setState(() => _showModels = false);
          },
        );
      }).toList(),
    );
  }

  Widget _buildAttachmentMenu() {
    return _buildFloatingMenu([
      _buildMenuItem(
        iconData: Icons.camera_alt_outlined,
        title: '拍攝照片',
        subtitle: '使用相機拍照並傳送',
        onTap: () {
          setState(() => _showAttachments = false);
          _takePhoto();
        },
      ),
      _buildMenuItem(
        iconData: Icons.image_outlined,
        title: '從相簿選擇',
        subtitle: '選擇手機中的圖片',
        onTap: () async {
          setState(() => _showAttachments = false);
          final result = await FilePicker.pickFiles(
            type: FileType.image,
            allowMultiple: true,
            withData: true,
          );
          if (result != null) {
            setState(() => _selectedFiles.addAll(result.files));
          }
        },
      ),
      _buildMenuItem(
        iconData: Icons.insert_drive_file_outlined,
        title: '傳送檔案',
        subtitle: '選擇任何類型的檔案',
        onTap: () {
          setState(() => _showAttachments = false);
          _pickFiles();
        },
      ),
      _buildMenuItem(
        iconData: Icons.link_outlined,
        title: '添加連結',
        subtitle: '輸入網址分享內容',
        onTap: () {
          setState(() => _showAttachments = false);
          _addLinkDialog();
        },
      ),
    ]);
  }

  Widget _buildFloatingMenu(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignSystem.space8),
      decoration: BoxDecoration(
        borderRadius: DesignSystem.borderXL,
        boxShadow: DesignSystem.shadowSoft,
      ),
      child: ClipRRect(
        borderRadius: DesignSystem.borderXL,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: symmetricAll(DesignSystem.space8),
            decoration: BoxDecoration(
              color: bg2.withOpacity(0.8),
              borderRadius: DesignSystem.borderXL,
              border: Border.all(color: bg3.withOpacity(0.4), width: 0.5),
            ),
            child: column(children),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData iconData,
    required String title,
    required String subtitle,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return inkWell(
      container(
        row(
          [
            container(
              Icon(iconData, size: 20, color: isSelected ? Colors.white : tx6),
              width: 36,
              height: 36,
              color: isSelected ? primary : bg3.withOpacity(0.3),
              radius: DesignSystem.borderM,
            ),
            width(DesignSystem.space12),
            expand(
              column([
                text(
                  title,
                  14,
                  isSelected ? fw7 : fw6,
                  isSelected ? primary : tx1,
                ),
                text(subtitle, 11, fw4, tx6),
              ], ca: CrossAxisAlignment.start),
            ),
            if (isSelected) icon(Icons.check_circle_rounded, 18, primary),
          ],
          ma: maC,
          ca: caC,
        ),
        padding: symmetric(DesignSystem.space10, DesignSystem.space8),
      ),
      onTap,
      radius: DesignSystem.borderM,
    );
  }

  Widget _buildCommandMenu() {
    return _buildFloatingMenu(
      _commands
          .map(
            (cmd) => _buildMenuItem(
              iconData: cmd.icon,
              title: cmd.name,
              subtitle: cmd.description,
              onTap: () async {
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
            color: bg3.withOpacity(0.4),
            radius: DesignSystem.borderM,
            border: Border.all(color: bg3.withOpacity(0.2), width: 0.5),
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
      color: bg3.withOpacity(0.4),
      radius: DesignSystem.borderM,
      border: Border.all(color: bg3.withOpacity(0.2), width: 0.5),
    );
  }

  Widget _buildSendButton() {
    return container(
      IconButton(
        onPressed: _handleSend,
        icon: icon(Icons.arrow_upward_rounded, 18, Colors.white),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      ),
      key: const ValueKey('send'),
      color: primary,
      radius: DesignSystem.borderM,
    );
  }

  Widget _buildStopButton() {
    return container(
      IconButton(
        onPressed: () => widget.chatController.stopGeneration(),
        icon: icon(Icons.stop_rounded, 16, Colors.white),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      ),
      key: const ValueKey('stop'),
      color: CommonColors.error,
      radius: DesignSystem.borderM,
    );
  }

  Widget _buildVoiceButton() {
    return IconButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        widget.onVoicePressed?.call();
      },
      icon: icon(Icons.mic_rounded, 22, tx6),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      key: const ValueKey('voice'),
    );
  }
}
