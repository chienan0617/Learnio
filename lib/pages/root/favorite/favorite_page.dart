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
      body: column([
        _buildHeader(context),
        expand(
          favorites.isEmpty ? _buildEmptyState() : _buildFavoriteList(favorites),
        ),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return container(
      row([
        iconButton(
          icon(Icons.menu_outlined, 26, tx1),
          () {
            HapticFeedback.lightImpact();
            Scaffold.of(context).openDrawer();
          },
        ),
        width(DesignSystem.space8),
        text('收藏', 24, fw7),
      ]),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + DesignSystem.space12,
        left: DesignSystem.space12,
        right: DesignSystem.space20,
        bottom: DesignSystem.space16,
      ),
    );
  }

  Widget _buildEmptyState() {
    return center(
      column(
        [
          container(
            icon(Icons.bookmark_border_rounded, 48, tx6.withOpacity(0.3)),
            padding: symmetricAll(DesignSystem.space24),
            color: bg2,
            shape: BoxShape.circle,
          ),
          height(DesignSystem.space24),
          text('還沒有任何收藏', 18, fw7, tx6),
          height(DesignSystem.space8),
          text('在對話中點擊書籤圖示來收藏訊息', 14, fw4, tx6.withOpacity(0.6)),
        ],
        ma: MainAxisAlignment.center,
        ca: CrossAxisAlignment.center,
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
    return container(
      inkWell(
        padding(
          const EdgeInsets.all(DesignSystem.space16),
          column([
            row([
              icon(Icons.chat_bubble_outline_rounded, 14, tx6),
              width(DesignSystem.space8),
              expand(
                text(
                  convTitle,
                  12,
                  fw6,
                  tx6,
                  false,
                  null,
                  fsN,
                  TextAlign.start,
                  1,
                  TextOverflow.ellipsis,
                ),
              ),
              inkWell(
                icon(Icons.bookmark_rounded, 20, primary),
                () {
                  HapticFeedback.lightImpact();
                  widget.favoriteController.toggleFavorite(msg);
                  setState(() {});
                },
              ),
            ]),
            height(DesignSystem.space12),
            text(
              msg.content,
              14,
              fw4,
              tx1,
              false,
              null,
              fsN,
              TextAlign.start,
              4,
              TextOverflow.ellipsis,
            ),
          ]),
        ),
        () {
          HapticFeedback.lightImpact();
          widget.onOpenConversation(msg.conversationId);
        },
        radius: DesignSystem.borderM,
      ),
      margin: const EdgeInsets.only(bottom: DesignSystem.space16),
      color: bg2,
      radius: DesignSystem.borderM,
      border: Border.all(color: bg3.withOpacity(0.4), width: 0.5),
      shadow: DesignSystem.shadowSoft,
    );
  }
}
