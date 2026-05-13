import 'package:learnio/script/types/conversation.dart';
import 'package:learnio/script/types/project.dart';

class AppSearchController {
  void Function()? onStateChanged;

  List<SearchResult> search({
    required String query,
    required List<Conversation> conversations,
    required List<Project> projects,
  }) {
    if (query.trim().isEmpty) return [];

    final lower = query.toLowerCase();
    final results = <SearchResult>[];

    // 搜尋對話
    for (final conv in conversations) {
      if (conv.title.toLowerCase().contains(lower)) {
        results.add(SearchResult(
          type: SearchResultType.conversation,
          title: conv.title,
          subtitle: conv.preview,
          id: conv.id,
        ));
      }

      // 搜尋訊息內容
      for (final msg in conv.messages) {
        if (msg.content.toLowerCase().contains(lower)) {
          results.add(SearchResult(
            type: SearchResultType.message,
            title: conv.title,
            subtitle: _highlightSnippet(msg.content, lower),
            id: msg.id,
            parentId: conv.id,
          ));
        }
      }
    }

    // 搜尋專案
    for (final proj in projects) {
      if (proj.name.toLowerCase().contains(lower) ||
          proj.description.toLowerCase().contains(lower)) {
        results.add(SearchResult(
          type: SearchResultType.project,
          title: proj.name,
          subtitle: proj.description,
          id: proj.id,
        ));
      }
    }

    return results;
  }

  String _highlightSnippet(String content, String query) {
    final idx = content.toLowerCase().indexOf(query);
    if (idx == -1) return content.substring(0, content.length.clamp(0, 80));

    final start = (idx - 20).clamp(0, content.length);
    final end = (idx + query.length + 40).clamp(0, content.length);
    final prefix = start > 0 ? '...' : '';
    final suffix = end < content.length ? '...' : '';

    return '$prefix${content.substring(start, end)}$suffix';
  }
}

enum SearchResultType { conversation, message, project }

class SearchResult {
  final SearchResultType type;
  final String title;
  final String subtitle;
  final String id;
  final String? parentId;

  SearchResult({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.id,
    this.parentId,
  });
}
