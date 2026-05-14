import 'package:learnio/base.dart';
import 'package:learnio/script/controller/chat/chat_controller.dart';
import 'package:learnio/script/controller/chat/conversation_controller.dart';

class ChatCommand {
  final String name;
  final String description;
  final IconData icon;
  final Future<void> Function(BuildContext context, ChatController chatController, ConversationController conversationController) execute;

  ChatCommand({
    required this.name,
    required this.description,
    required this.icon,
    required this.execute,
  });
}

class CommandController {
  static List<ChatCommand> getCommands() {
    return [
      ChatCommand(
        name: '清除對話',
        description: '開始一個新的對話並清除當前畫面',
        icon: Icons.delete_sweep_outlined,
        execute: (context, chat, conv) async {
          conv.startNewConversation();
        },
      ),
      ChatCommand(
        name: '總結對話',
        description: '讓 AI 總結目前的對話內容',
        icon: Icons.summarize_outlined,
        execute: (context, chat, conv) async {
          await chat.sendMessage('請幫我總結目前的對話內容。');
        },
      ),
      ChatCommand(
        name: '獲取幫助',
        description: '顯示如何使用 Learnio 的說明',
        icon: Icons.help_outline,
        execute: (context, chat, conv) async {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('正在開啟幫助文件...')),
          );
        },
      ),
    ];
  }
}
