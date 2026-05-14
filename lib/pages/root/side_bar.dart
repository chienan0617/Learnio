import 'package:learnio/base.dart';
import 'package:learnio/script/controller/chat/conversation_controller.dart';
import 'package:learnio/script/controller/chat/search_controller.dart';
import 'package:learnio/script/controller/chat/project_controller.dart';

class SideBar extends StatefulWidget {
  final ConversationController conversationController;
  final AppSearchController searchController;
  final ProjectController projectController;
  final void Function(String pageKey) onNavigate;
  final void Function(String conversationId) onSelectConversation;
  final VoidCallback onNewConversation;

  const SideBar({
    super.key,
    required this.conversationController,
    required this.searchController,
    required this.projectController,
    required this.onNavigate,
    required this.onSelectConversation,
    required this.onNewConversation,
  });

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _isSearching = false;
  List<SearchResult> _searchResults = [];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _isSearching = query.trim().isNotEmpty;
      _searchResults = widget.searchController.search(
        query: query,
        conversations: widget.conversationController.conversations,
        projects: widget.projectController.projects,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: bg1,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: column([
          _buildHeader(),
          _buildSearchBar(),
          expand(
            _isSearching ? _buildSearchResults() : _buildMainMenu(),
          ),
          const Divider(height: 1, thickness: 0.5, color: Colors.white10),
          _buildFooter(),
        ], ms: MainAxisSize.max),
      ),
    );
  }

  Widget _buildHeader() {
    return padding(
      const EdgeInsets.fromLTRB(
        DesignSystem.space20,
        DesignSystem.space20,
        DesignSystem.space20,
        DesignSystem.space12,
      ),
      row([
        // Logo
        container(
          logo(24, Colors.white),
          width: 42,
          height: 42,
          gradient: LinearGradient(
            colors: [primary, secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          radius: DesignSystem.borderM,
          shadow: [
            BoxShadow(
              color: primary.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        width(DesignSystem.space12),
        text('Learnio', 22, fw7),
        spacer(),
        // 新對話按鈕
        inkWell(
          container(
            icon(Icons.add_rounded, 20, tx1),
            padding: symmetricAll(DesignSystem.space8),
            color: bg2,
            radius: DesignSystem.borderM,
            border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
          ),
          () {
            HapticFeedback.lightImpact();
            widget.onNewConversation();
            Navigator.pop(context);
          },
        ),
      ]),
    );
  }

  Widget _buildSearchBar() {
    return padding(
      const EdgeInsets.symmetric(
        horizontal: DesignSystem.space16,
        vertical: DesignSystem.space8,
      ),
      container(
        TextField(
          controller: _searchCtrl,
          onChanged: _onSearch,
          style: tsBodyMedium.copyWith(color: tx1),
          cursorColor: primary,
          decoration: InputDecoration(
            hintText: '搜尋對話...',
            hintStyle: tsBodyMedium.copyWith(color: tx6.withOpacity(0.5)),
            prefixIcon: icon(Icons.search_outlined, 20, tx6),
            suffixIcon: _isSearching
                ? iconButton(
                    icon(Icons.close_outlined, 18, tx6),
                    () {
                      _searchCtrl.clear();
                      _onSearch('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        color: bg2,
        radius: DesignSystem.borderXL,
        border: Border.all(color: bg3.withOpacity(0.3), width: 0.5),
      ),
    );
  }

  Widget _buildMainMenu() {
    final conversations = widget.conversationController.conversations;
    final currentId = widget.conversationController.current?.id;

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.space12,
        vertical: DesignSystem.space8,
      ),
      children: [
        // 功能選單
        _menuItem(Icons.chat_outlined, '聊天', 'chat'),
        _menuItem(Icons.folder_outlined, '專案', 'project'),
        _menuItem(Icons.bookmark_outlined, '收藏', 'favorite'),
        _menuItem(Icons.school_outlined, '學習庫', 'learning'),
        _menuItem(Icons.settings_outlined, '設定', 'settings'),

        // 分隔線
        padding(
          const EdgeInsets.fromLTRB(
            DesignSystem.space8,
            DesignSystem.space20,
            DesignSystem.space8,
            DesignSystem.space8,
          ),
          row([
            text('最近對話', 12, fw7, tx6),
            spacer(),
            text(
              '${conversations.length}',
              12,
              fw5,
              tx6.withOpacity(0.5),
            ),
          ]),
        ),

        // 歷史列表
        ...conversations.map((conv) {
          final isActive = conv.id == currentId;
          return container(
            ListTile(
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onSelectConversation(conv.id);
                Navigator.pop(context);
              },
              dense: true,
              visualDensity: VisualDensity.compact,
              leading: icon(
                Icons.chat_bubble_outline_rounded,
                16,
                isActive ? primary : tx6,
              ),
              title: text(
                conv.title,
                14,
                isActive ? fw6 : fw4,
                isActive ? tx1 : tx2,
                false,
                null,
                fsN,
                TextAlign.start,
                1,
                TextOverflow.ellipsis,
              ),
              subtitle: text(
                conv.timeLabel,
                10,
                fw4,
                tx6.withOpacity(0.6),
              ),
              trailing: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: icon(
                  Icons.more_vert_rounded,
                  16,
                  tx6.withOpacity(0.5),
                ),
                onSelected: (value) {
                  if (value == 'rename') {
                    _showRenameConvDialog(conv.id, conv.title);
                  } else if (value == 'delete') {
                    _showDeleteConvDialog(conv.id, conv.title);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'rename',
                    height: 32,
                    child: row([
                      icon(Icons.edit_outlined, 14, tx2),
                      width(8),
                      text('重新命名', 12, fw4, tx6),
                    ]),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    height: 32,
                    child: row([
                      icon(
                        Icons.delete_outline_rounded,
                        14,
                        CommonColors.error,
                      ),
                      width(8),
                      text(
                        '刪除',
                        12,
                        fw4,
                        CommonColors.error,
                      ),
                    ]),
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderM),
            ),
            margin: const EdgeInsets.only(bottom: 4),
            color: isActive ? primary.withOpacity(0.1) : Colors.transparent,
            radius: DesignSystem.borderM,
          );
        }),
      ],
    );
  }

  void _showRenameConvDialog(String id, String oldTitle) {
    final ctrl = TextEditingController(text: oldTitle);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: bg1_5,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderL),
        title: text('重新命名對話', 22, fw7),
        content: TextField(
          controller: ctrl,
          style: tsBodyMedium,
          autofocus: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: bg2,
            border: OutlineInputBorder(
              borderRadius: DesignSystem.borderM,
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: text('取消', 14, fw4, tx6),
          ),
          TextButton(
            onPressed: () {
              final newTitle = ctrl.text.trim();
              if (newTitle.isNotEmpty) {
                widget.conversationController.renameConversation(id, newTitle);
                Navigator.pop(ctx);
                setState(() {});
              }
            },
            child: text('確定', 14, fw4, primary),
          ),
        ],
      ),
    );
  }

  void _showDeleteConvDialog(String id, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: bg1_5,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderL),
        title: text('刪除對話？', 22, fw7),
        content: text('確定要刪除「$title」嗎？', 14, fw4, tx2),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: text('取消', 14, fw4, tx6),
          ),
          TextButton(
            onPressed: () {
              widget.conversationController.deleteConversation(id);
              Navigator.pop(ctx);
              setState(() {});
            },
            child: text('刪除', 14, fw4, CommonColors.error),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData iconData, String title, String key) {
    return container(
      ListTile(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onNavigate(key);
          Navigator.pop(context);
        },
        dense: true,
        leading: icon(iconData, 22, tx1.withOpacity(0.8)),
        title: text(title, 14, fw6, tx1),
        shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderM),
        hoverColor: bg2,
        splashColor: primary.withOpacity(0.1),
      ),
      margin: const EdgeInsets.only(bottom: 4),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return center(
        text('找不到結果', 14, fw4, tx6),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.space12,
        vertical: DesignSystem.space8,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (_, i) {
        final r = _searchResults[i];
        IconData iconData;
        switch (r.type) {
          case SearchResultType.conversation:
            iconData = Icons.chat_bubble_outline_rounded;
          case SearchResultType.message:
            iconData = Icons.textsms_outlined;
          case SearchResultType.project:
            iconData = Icons.folder_outlined;
        }

        return ListTile(
          onTap: () {
            if (r.type == SearchResultType.project) {
              widget.onNavigate('project');
            } else {
              final convId = r.parentId ?? r.id;
              widget.onSelectConversation(convId);
            }
            Navigator.pop(context);
          },
          dense: true,
          leading: icon(iconData, 18, tx6),
          title: text(
            r.title,
            14,
            fw6,
            tx1,
            false,
            null,
            fsN,
            TextAlign.start,
            1,
            TextOverflow.ellipsis,
          ),
          subtitle: text(
            r.subtitle,
            12,
            fw4,
            tx6,
            false,
            null,
            fsN,
            TextAlign.start,
            2,
            TextOverflow.ellipsis,
          ),
          shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderM),
        );
      },
    );
  }

  Widget _buildFooter() {
    return padding(
      const EdgeInsets.all(DesignSystem.space16),
      inkWell(
        container(
          row([
            // 頭像佔位
            container(
              icon(Icons.person_rounded, 20, primary),
              width: 32,
              height: 32,
              color: primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            width(DesignSystem.space12),
            expand(
              column(
                [
                  text(
                    'Premium User',
                    13,
                    fw7,
                  ),
                  text(
                    'Version ${System.version}',
                    10,
                    fw4,
                    tx6,
                  ),
                ],
                ca: CrossAxisAlignment.start,
              ),
            ),
            width(DesignSystem.space8),
            buildAlphaTag(),
          ]),
          padding: symmetric(DesignSystem.space12, DesignSystem.space12),
          color: bg2,
          radius: DesignSystem.borderM,
          border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
        ),
        () {
          // TODO: 使用者資訊
        },
      ),
    );
  }
}

Widget buildAlphaTag() {
  return container(
    text(
      'ALPHA',
      9,
      fw7,
      Colors.orangeAccent,
    ),
    padding: symmetric(6, 2),
    color: Colors.orangeAccent.withOpacity(0.1),
    radius: DesignSystem.borderS,
    border: Border.all(
      color: Colors.orangeAccent.withOpacity(0.3),
      width: 0.5,
    ),
  );
}
