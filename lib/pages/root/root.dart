import 'package:learnio/base.dart';
import 'package:learnio/script/controller/chat/chat_controller.dart';
import 'package:learnio/script/controller/chat/conversation_controller.dart';
import 'package:learnio/script/controller/chat/project_controller.dart';
import 'package:learnio/script/controller/chat/favorite_controller.dart';
import 'package:learnio/script/controller/chat/learning_controller.dart';
import 'package:learnio/script/controller/chat/search_controller.dart';
import 'package:learnio/pages/root/side_bar.dart';
import 'package:learnio/pages/root/chat/chat_page.dart';
import 'package:learnio/pages/root/project/project_page.dart';
import 'package:learnio/pages/root/favorite/favorite_page.dart';
import 'package:learnio/pages/root/learning/learning_page.dart';
import 'package:learnio/pages/root/settings/settings_page.dart';
import 'package:learnio/pages/root/user/user_info_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  // Controllers
  late final ConversationController _convController;
  late final ChatController _chatController;
  late final ProjectController _projectController;
  late final FavoriteController _favoriteController;
  late final LearningController _learningController;
  late final AppSearchController _searchController;

  String _currentPage = 'chat';

  @override
  void initState() {
    super.initState();
    Rebuild.register('root', () => setState(() {}));

    _convController = ConversationController();
    _chatController = ChatController(_convController);
    _projectController = ProjectController();
    _favoriteController = FavoriteController();
    _learningController = LearningController();
    _searchController = AppSearchController();

    _convController.onStateChanged = () {
      if (mounted) setState(() {});
    };
  }

  void _navigateTo(String pageKey) {
    if (_currentPage == pageKey) return;
    setState(() => _currentPage = pageKey);
  }

  void _selectConversation(String conversationId) {
    _convController.selectConversation(conversationId);
    _chatController.syncSelectedModel();
    setState(() => _currentPage = 'chat');
  }

  void _startNewConversation() {
    _convController.startNewConversation();
    _chatController.syncSelectedModel();
    setState(() => _currentPage = 'chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg1,
      drawerScrimColor: Colors.black45,
      drawer: SideBar(
        conversationController: _convController,
        searchController: _searchController,
        projectController: _projectController,
        onNavigate: _navigateTo,
        onSelectConversation: _selectConversation,
        onNewConversation: _startNewConversation,
      ),
      body: Stack(
        children: [
          // Clean dark background
          Positioned.fill(
            child: Container(
              color: bg1, // Deep dark color
            ),
          ),
          // Main Content
          AnimatedSwitcher(
            duration: DesignSystem.animNormal,
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: container(
              _buildCurrentPage(),
              key: ValueKey(_currentPage),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentPage) {
      case 'chat':
        return ChatPage(
          chatController: _chatController,
          conversationController: _convController,
          learningController: _learningController,
        );
      case 'project':
        return ProjectPage(
          projectController: _projectController,
          onOpenConversation: _selectConversation,
        );
      case 'favorite':
        return FavoritePage(
          favoriteController: _favoriteController,
          conversationController: _convController,
          onOpenConversation: _selectConversation,
        );
      case 'learning':
        return LearningPage(
          learningController: _learningController,
        );
      case 'settings':
        return const SettingsPage();
      case 'user':
        return const UserInfoPage();
      default:
        return ChatPage(
          chatController: _chatController,
          conversationController: _convController,
          learningController: _learningController,
        );
    }
  }
}
