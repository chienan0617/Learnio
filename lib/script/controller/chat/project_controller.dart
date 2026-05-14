import 'package:learnio/base.dart';
import 'package:learnio/script/controller/data/data_controller.dart';
import 'package:learnio/script/types/project.dart';

class ProjectController {
  final List<Project> _projects = [];
  void Function()? onStateChanged;

  List<Project> get projects => List.unmodifiable(_projects);

  ProjectController() {
    _loadFromStorage();
  }

  void _loadFromStorage() {
    final stored = DataController.getProjects();
    if (stored.isEmpty) {
      _loadMockData();
    } else {
      _projects.addAll(stored);
      _projects.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
  }

  Project createProject({
    required String name,
    String description = '',
    Color? color,
  }) {
    final project = Project(
      id: 'proj_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      createdAt: DateTime.now(),
      color: color ?? primary,
    );
    _projects.insert(0, project);
    DataController.saveProject(project);
    onStateChanged?.call();
    return project;
  }

  void deleteProject(String id) {
    _projects.removeWhere((p) => p.id == id);
    DataController.deleteProject(id);
    onStateChanged?.call();
  }

  void addConversationToProject(String projectId, String conversationId) {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index != -1) {
      final project = _projects[index];
      if (!project.conversationIds.contains(conversationId)) {
        project.conversationIds.add(conversationId);
        DataController.saveProject(project);
        onStateChanged?.call();
      }
    }
  }

  void _loadMockData() {
    final mockData = [
      Project(
        id: 'proj_mock_1',
        name: 'Flutter 學習',
        description: '記錄所有 Flutter 相關的學習對話',
        conversationIds: ['conv_mock_1'],
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        color: hexColor('#3B82F6'),
      ),
      Project(
        id: 'proj_mock_2',
        name: 'AI & ML 筆記',
        description: '人工智能與機器學習的學習筆記',
        conversationIds: ['conv_mock_3'],
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
        color: hexColor('#8B5CF6'),
      ),
    ];
    _projects.addAll(mockData);
    for (var p in mockData) {
      DataController.saveProject(p);
    }
  }
}
