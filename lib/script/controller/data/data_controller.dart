import 'package:learnio/base.dart';
import 'package:learnio/script/types/conversation.dart';
import 'package:learnio/script/types/project.dart';
import 'package:learnio/script/types/learning_item.dart';

class DataController {
  static final Database _projectsBox = Database('projects');
  static final Database _conversationsBox = Database('conversations');
  static final Database _learningItemsBox = Database('learning_items');

  static List<Registerable> get registrables => [
    _projectsBox,
    _conversationsBox,
    _learningItemsBox,
  ];

  // --- Projects ---
  static List<Project> getProjects() => _projectsBox.values<Project>().toList();
  static Future<void> saveProject(Project project) => _projectsBox.put(project.id, project);
  static Future<void> deleteProject(String id) async => _projectsBox.delete(id);

  // --- Conversations ---
  static List<Conversation> getConversations() => _conversationsBox.values<Conversation>().toList();
  static Future<void> saveConversation(Conversation conversation) => _conversationsBox.put(conversation.id, conversation);
  static Future<void> deleteConversation(String id) async => _conversationsBox.delete(id);

  // --- Learning Items ---
  static List<LearningItem> getLearningItems() => _learningItemsBox.values<LearningItem>().toList();
  static Future<void> saveLearningItem(LearningItem item) => _learningItemsBox.put(item.id, item);
  static Future<void> deleteLearningItem(String id) async => _learningItemsBox.delete(id);

  // --- General ---
  static Future<void> clearAll() async {
    await _projectsBox.getBox().clear();
    await _conversationsBox.getBox().clear();
    await _learningItemsBox.getBox().clear();
  }
}
