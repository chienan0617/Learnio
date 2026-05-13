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
                ? _buildEmptyState()
                : _buildFavoriteList(favorites),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + DesignSystem.space12,
        left: DesignSystem.space12,
        right: DesignSystem.space20,
        bottom: DesignSystem.space16,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu_rounded, color: tx1, size: 26),
          ),
          const SizedBox(width: DesignSystem.space8),
          Text('收藏', style: tsTitleLarge.copyWith(fontSize: 24)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(DesignSystem.space24),
            decoration: BoxDecoration(
              color: bg2,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.bookmark_border_rounded, size: 48, color: tx6.withOpacity(0.3)),
          ),
          const SizedBox(height: DesignSystem.space24),
          Text('還沒有任何收藏', style: tsTitleMedium.copyWith(color: tx6)),
          const SizedBox(height: DesignSystem.space8),
          Text('在對話中點擊書籤圖示來收藏訊息', style: tsBodyMedium.copyWith(color: tx6.withOpacity(0.6))),
        ],
      ),
    );
  }

  Widget _buildFavoriteList(List<ChatMessage> favorites) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.space20),
      itemCount: favorites.length,
      itemBuilder: (context, index) => _buildCard(favorites[index]),
    );
  }

  Widget _buildCard(ChatMessage msg) {
    final convTitle = widget.favoriteController.getConversationTitle(
      msg.conversationId,
      widget.conversationController.conversations,
    );
    return Container(
      margin: const EdgeInsets.only(bottom: DesignSystem.space16),
      decoration: BoxDecoration(
        color: bg2,
        borderRadius: DesignSystem.borderM,
        border: Border.all(color: bg3.withOpacity(0.4), width: 0.5),
        boxShadow: DesignSystem.shadowSoft,
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onOpenConversation(msg.conversationId);
        },
        borderRadius: DesignSystem.borderM,
        child: Padding(
          padding: const EdgeInsets.all(DesignSystem.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.chat_bubble_outline_rounded, size: 14, color: tx6),
                  const SizedBox(width: DesignSystem.space8),
                  Expanded(
                    child: Text(
                      convTitle,
                      style: tsCaption.copyWith(fontWeight: fw6, color: tx6),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.favoriteController.toggleFavorite(msg);
                      setState(() {});
                    },
                    child: Icon(Icons.bookmark_rounded, size: 20, color: primary),
                  ),
                ],
              ),
              const SizedBox(height: DesignSystem.space12),
              Text(
                msg.content,
                style: tsBodyMedium.copyWith(color: tx1, height: 1.6),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
