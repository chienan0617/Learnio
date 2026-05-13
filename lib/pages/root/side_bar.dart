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
      width: MediaQuery.of(context).size.width * 0.82,
      backgroundColor: bg1,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: _isSearching ? _buildSearchResults() : _buildMainMenu(),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          // Logo
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, secondary],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_awesome, size: 22, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text('Learnio', style: TextStyle(
            color: tx1, fontSize: 22, fontWeight: fw8, letterSpacing: -0.5,
          )),
          const Spacer(),
          // 新對話按鈕
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onNewConversation();
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bg2, borderRadius: BorderRadius.circular(10),
                border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
              ),
              child: Icon(Icons.edit_square, size: 18, color: tx2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: bg2, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: bg3.withOpacity(0.3), width: 0.5),
        ),
        child: TextField(
          controller: _searchCtrl,
          onChanged: _onSearch,
          style: TextStyle(color: tx1, fontSize: 14),
          cursorColor: primary,
          decoration: InputDecoration(
            hintText: '搜尋對話...',
            hintStyle: TextStyle(color: tx6.withOpacity(0.5), fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: tx6, size: 18),
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
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildMainMenu() {
    final conversations = widget.conversationController.conversations;
    final currentId = widget.conversationController.current?.id;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: [
        // 功能選單
        _menuItem(Icons.chat_rounded, '聊天', 'chat'),
        _menuItem(Icons.folder_rounded, '專案', 'project'),
        _menuItem(Icons.bookmark_rounded, '收藏', 'favorite'),
        _menuItem(Icons.school_rounded, '學習庫', 'learning'),
        _menuItem(Icons.settings_rounded, '設定', 'settings'),

        // 分隔線
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(children: [
            Text('最近對話', style: TextStyle(color: tx6, fontSize: 12, fontWeight: fw6)),
            const Spacer(),
            Text('${conversations.length}',
                style: TextStyle(color: tx6.withOpacity(0.5), fontSize: 11)),
          ]),
        ),

        // 歷史列表
        ...conversations.map((conv) {
          final isActive = conv.id == currentId;
          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: isActive ? primary.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
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
                  style: TextStyle(
                    color: isActive ? tx1 : tx2,
                    fontSize: 13, fontWeight: isActive ? fw6 : fw4,
                  ),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(conv.timeLabel,
                  style: TextStyle(color: tx6.withOpacity(0.6), fontSize: 11)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
        leading: Icon(icon, size: 20, color: tx2),
        title: Text(title, style: TextStyle(color: tx1, fontSize: 14, fontWeight: fw5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        hoverColor: bg2,
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text('找不到結果', style: TextStyle(color: tx6, fontSize: 14)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              style: TextStyle(color: tx1, fontSize: 13, fontWeight: fw5),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(r.subtitle,
              style: TextStyle(color: tx6, fontSize: 12),
              maxLines: 2, overflow: TextOverflow.ellipsis),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: bg2, borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          Icon(Icons.vibration_rounded, size: 12, color: tx6.withOpacity(0.4)),
          const SizedBox(width: 8),
          Text('Version ${System.version}',
              style: TextStyle(color: tx6.withOpacity(0.5), fontSize: 11, fontWeight: fw5)),
          const Spacer(),
          buildAlphaTag(),
        ]),
      ),
    );
  }

  void _showDeleteConvDialog(String id, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: bg1_5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('刪除對話？', style: TextStyle(color: tx1, fontWeight: fw7)),
        content: Text('確定要刪除「$title」嗎？', style: TextStyle(color: tx2)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('取消', style: TextStyle(color: tx6)),
          ),
          TextButton(
            onPressed: () {
              widget.conversationController.deleteConversation(id);
              Navigator.pop(ctx);
              setState(() {});
            },
            child: Text('刪除', style: TextStyle(color: CommonColors.error)),
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
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: Colors.orangeAccent.withOpacity(0.3), width: 0.5),
    ),
    child: const Text('ALPHA',
        style: TextStyle(color: Colors.orangeAccent, fontSize: 9, fontWeight: fw7)),
  );
}
