import 'package:learnio/script/types/learning_item.dart';

class LearningController {
  final List<LearningItem> _items = [];
  void Function()? onStateChanged;

  List<LearningItem> get items => List.unmodifiable(_items);

  LearningController() {
    _loadMockData();
  }

  LearningItem addItem({
    required String title,
    required String summary,
    String? sourceMessageId,
    List<String>? tags,
  }) {
    final item = LearningItem(
      id: 'learn_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      summary: summary,
      sourceMessageId: sourceMessageId,
      tags: tags,
      createdAt: DateTime.now(),
    );
    _items.insert(0, item);
    onStateChanged?.call();
    return item;
  }

  void deleteItem(String id) {
    _items.removeWhere((i) => i.id == id);
    onStateChanged?.call();
  }

  List<LearningItem> searchItems(String query) {
    if (query.isEmpty) return _items;
    final lower = query.toLowerCase();
    return _items.where((item) {
      return item.title.toLowerCase().contains(lower) ||
          item.summary.toLowerCase().contains(lower) ||
          item.tags.any((t) => t.toLowerCase().contains(lower));
    }).toList();
  }

  void _loadMockData() {
    _items.addAll([
      LearningItem(
        id: 'learn_mock_1',
        title: 'Widget 生命週期',
        summary: 'StatefulWidget 的七個生命週期方法：createState → initState → '
            'didChangeDependencies → build → didUpdateWidget → setState → dispose',
        tags: ['Flutter', 'Widget', '生命週期'],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      LearningItem(
        id: 'learn_mock_2',
        title: 'async/await 原理',
        summary: 'Future 是 Dart 異步操作的核心類別。async/await 是語法糖，'
            '讓異步代碼可以用同步的方式書寫，提高可讀性。',
        tags: ['Dart', '異步', 'Future'],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      LearningItem(
        id: 'learn_mock_3',
        title: '觀察者模式',
        summary: '定義一對多依賴關係，當主題狀態改變時通知所有觀察者。'
            '在 Flutter 中的實現：ChangeNotifier + Listener。',
        tags: ['設計模式', 'Observer', 'Flutter'],
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ]);
  }
}
