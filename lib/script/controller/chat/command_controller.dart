import 'package:learnio/base.dart';
import 'package:learnio/script/controller/chat/chat_controller.dart';
import 'package:learnio/script/controller/chat/conversation_controller.dart';
import 'package:http/http.dart' as http;

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
  static const String _commandsUrl = 'https://chienan0617.github.io/layout/dev.cas.learnio/commands/commands_list.json';
  static List<ChatCommand> _remoteCommands = [];
  static bool _hasFetched = false;

  static List<ChatCommand> getCommands() {
    return _remoteCommands;
  }

  static Future<List<ChatCommand>> fetchRemoteCommands() async {
    try {
      final response = await http.get(Uri.parse(_commandsUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        _remoteCommands = data.where((item) => item['enable'] == true).map((item) {
          return ChatCommand(
            name: item['name'] ?? '',
            description: item['desc'] ?? '',
            icon: AppIcons.getIcon(item['icon'] ?? 'help_outline'),
            execute: (context, chat, conv) async {
              if (item['output'] != null) {
                await chat.sendMessage(item['output']);
              }
            },
          );
        }).toList();
        _hasFetched = true;
        return _remoteCommands;
      }
    } catch (e) {
      logE('Error fetching remote commands: $e');
    }
    return [];
  }
}
