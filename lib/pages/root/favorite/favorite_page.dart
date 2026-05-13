import 'package:learnio/base.dart';
import 'package:learnio/script/controller/chat/favorite_controller.dart';
import 'package:learnio/script/controller/chat/conversation_controller.dart';
import 'package:learnio/script/types/chat_message.dart';

class FavoritePage extends StatefulWidget {
  final FavoriteController favoriteController;
  final ConversationController conversationController;
  final void Function(String conversationId) onOpenConversation;

  const FavoritePage({
    super.key,
    required this.favoriteController,
    required this.conversationController,
    required this.onOpenConversation,
  });

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final favorites = widget.favoriteController.getFavorites(
      widget.conversationController.conversations,
    );

    return Scaffold(
      backgroundColor: bg1,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: favorites.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bookmark_border_rounded,
                            size: 64, color: tx6.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text('還沒有收藏',
                            style: TextStyle(color: tx6, fontSize: 16, fontWeight: fw5)),
                        const SizedBox(height: 8),
                        Text('在對話中點擊書籤圖示來收藏訊息',
                            style: TextStyle(color: tx6.withOpacity(0.6), fontSize: 13)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) =>
                        _buildCard(favorites[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20, right: 20, bottom: 16,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu_rounded, color: tx1, size: 24),
          ),
          const SizedBox(width: 12),
          Text('收藏', style: TextStyle(color: tx1, fontSize: 24, fontWeight: fw8)),
        ],
      ),
    );
  }

  Widget _buildCard(ChatMessage msg) {
    final convTitle = widget.favoriteController.getConversationTitle(
      msg.conversationId, widget.conversationController.conversations,
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bg2, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
      ),
      child: InkWell(
        onTap: () => widget.onOpenConversation(msg.conversationId),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(Icons.chat_bubble_outline_rounded, size: 14, color: tx6),
                const SizedBox(width: 6),
                Expanded(child: Text(convTitle,
                    style: TextStyle(color: tx6, fontSize: 12, fontWeight: fw5),
                    maxLines: 1, overflow: TextOverflow.ellipsis)),
                InkWell(
                  onTap: () {
                    widget.favoriteController.toggleFavorite(msg);
                    setState(() {});
                  },
                  child: Icon(Icons.bookmark_rounded, size: 18, color: primary),
                ),
              ]),
              const SizedBox(height: 10),
              Text(msg.content,
                  style: TextStyle(color: tx2, fontSize: 14, height: 1.5),
                  maxLines: 4, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
