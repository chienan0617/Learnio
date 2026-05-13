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
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: _isSearching ? _buildSearchResults() : _buildMainMenu(),
            ),
            const Divider(height: 1, thickness: 0.5, color: Colors.white10),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          DesignSystem.space20, DesignSystem.space20, DesignSystem.space20, DesignSystem.space12),
      child: Row(
        children: [
          // Logo
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: DesignSystem.borderM,
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.auto_awesome, size: 24, color: Colors.white),
          ),
          const SizedBox(width: DesignSystem.space12),
          Text('Learnio', style: tsTitleLarge),
          const Spacer(),
          // 新對話按鈕
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onNewConversation();
              Navigator.pop(context);
            },
            borderRadius: DesignSystem.borderM,
            child: Container(
              padding: const EdgeInsets.all(DesignSystem.space8),
              decoration: BoxDecoration(
                color: bg2,
                borderRadius: DesignSystem.borderM,
                border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
              ),
              child: Icon(Icons.edit_square, size: 20, color: tx1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.space16, vertical: DesignSystem.space8),
      child: Container(
        decoration: BoxDecoration(
          color: bg2,
          borderRadius: DesignSystem.borderXL,
          border: Border.all(color: bg3.withOpacity(0.3), width: 0.5),
        ),
        child: TextField(
          controller: _searchCtrl,
          onChanged: _onSearch,
          style: tsBodyMedium.copyWith(color: tx1),
          cursorColor: primary,
          decoration: InputDecoration(
            hintText: '搜尋對話...',
            hintStyle: tsBodyMedium.copyWith(color: tx6.withOpacity(0.5)),
            prefixIcon: Icon(Icons.search_rounded, color: tx6, size: 20),
            suffixIcon: _isSearching
                ? IconButton(
                    icon: Icon(Icons.close_rounded, color: tx6, size: 18),
                    onPressed: () {
                      _searchCtrl.clear();
                      _onSearch('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildMainMenu() {
    final conversations = widget.conversationController.conversations;
    final currentId = widget.conversationController.current?.id;

    return ListView(
      padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.space12, vertical: DesignSystem.space8),
      children: [
        // 功能選單
        _menuItem(Icons.chat_rounded, '聊天', 'chat'),
        _menuItem(Icons.folder_rounded, '專案', 'project'),
        _menuItem(Icons.bookmark_rounded, '收藏', 'favorite'),
        _menuItem(Icons.school_rounded, '學習庫', 'learning'),
        _menuItem(Icons.settings_rounded, '設定', 'settings'),

        // 分隔線
        Padding(
          padding: const EdgeInsets.fromLTRB(
              DesignSystem.space8, DesignSystem.space20, DesignSystem.space8, DesignSystem.space8),
          child: Row(children: [
            Text('最近對話', style: tsCaption.copyWith(fontWeight: fw7)),
            const Spacer(),
            Text('${conversations.length}',
                style: tsCaption.copyWith(color: tx6.withOpacity(0.5))),
          ]),
        ),

        // 歷史列表
        ...conversations.map((conv) {
          final isActive = conv.id == currentId;
          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: isActive ? primary.withOpacity(0.1) : Colors.transparent,
              borderRadius: DesignSystem.borderM,
            ),
            child: ListTile(
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onSelectConversation(conv.id);
                Navigator.pop(context);
              },
              onLongPress: () {
                HapticFeedback.mediumImpact();
                _showDeleteConvDialog(conv.id, conv.title);
              },
              dense: true,
              visualDensity: VisualDensity.compact,
              leading: Icon(Icons.chat_bubble_outline_rounded,
                  size: 16, color: isActive ? primary : tx6),
              title: Text(conv.title,
                  style: tsBodyMedium.copyWith(
                    color: isActive ? tx1 : tx2,
                    fontWeight: isActive ? fw6 : fw4,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              subtitle: Text(conv.timeLabel,
                  style: tsCaption.copyWith(fontSize: 10, color: tx6.withOpacity(0.6))),
              shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderM),
            ),
          );
        }),
      ],
    );
  }

  Widget _menuItem(IconData icon, String title, String key) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onNavigate(key);
          Navigator.pop(context);
        },
        dense: true,
        leading: Icon(icon, size: 22, color: tx1.withOpacity(0.8)),
        title: Text(title, style: tsBodyMedium.copyWith(color: tx1, fontWeight: fw6)),
        shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderM),
        hoverColor: bg2,
        splashColor: primary.withOpacity(0.1),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text('找不到結果', style: tsBodyMedium.copyWith(color: tx6)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.space12, vertical: DesignSystem.space8),
      itemCount: _searchResults.length,
      itemBuilder: (_, i) {
        final r = _searchResults[i];
        IconData icon;
        switch (r.type) {
          case SearchResultType.conversation:
            icon = Icons.chat_bubble_outline_rounded;
          case SearchResultType.message:
            icon = Icons.textsms_outlined;
          case SearchResultType.project:
            icon = Icons.folder_outlined;
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
          leading: Icon(icon, size: 18, color: tx6),
          title: Text(r.title,
              style: tsBodyMedium.copyWith(color: tx1, fontWeight: fw6),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          subtitle: Text(r.subtitle,
              style: tsCaption, maxLines: 2, overflow: TextOverflow.ellipsis),
          shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderM),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(DesignSystem.space16),
      child: InkWell(
        onTap: () {
          // TODO: 使用者資訊
        },
        borderRadius: DesignSystem.borderM,
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: DesignSystem.space12, horizontal: DesignSystem.space12),
          decoration: BoxDecoration(
            color: bg2,
            borderRadius: DesignSystem.borderM,
            border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
          ),
          child: Row(children: [
            // 頭像佔位
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_rounded, size: 20, color: primary),
            ),
            const SizedBox(width: DesignSystem.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Premium User',
                      style: tsBodyMedium.copyWith(fontWeight: fw7, fontSize: 13)),
                  Text('Version ${System.version}',
                      style: tsCaption.copyWith(fontSize: 10, color: tx6)),
                ],
              ),
            ),
            const SizedBox(width: DesignSystem.space8),
            buildAlphaTag(),
          ]),
        ),
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
        title: Text('刪除對話？', style: tsTitleLarge),
        content: Text('確定要刪除「$title」嗎？', style: tsBodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('取消', style: tsBodyMedium.copyWith(color: tx6)),
          ),
          TextButton(
            onPressed: () {
              widget.conversationController.deleteConversation(id);
              Navigator.pop(ctx);
              setState(() {});
            },
            child: Text('刪除', style: tsBodyMedium.copyWith(color: CommonColors.error)),
          ),
        ],
      ),
    );
  }
}

Widget buildAlphaTag() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.orangeAccent.withOpacity(0.1),
      borderRadius: DesignSystem.borderS,
      border: Border.all(color: Colors.orangeAccent.withOpacity(0.3), width: 0.5),
    ),
    child: const Text('ALPHA',
        style: TextStyle(color: Colors.orangeAccent, fontSize: 9, fontWeight: fw7)),
  );
}
