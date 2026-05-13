import 'package:learnio/base.dart';
import 'package:learnio/script/controller/chat/learning_controller.dart';
import 'package:learnio/script/types/learning_item.dart';

class LearningPage extends StatefulWidget {
  final LearningController learningController;

  const LearningPage({super.key, required this.learningController});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    widget.learningController.onStateChanged = () {
      if (mounted) setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.learningController.searchItems(_searchQuery);

    return Scaffold(
      backgroundColor: bg1,
      body: Column(
        children: [
          _buildHeader(context),
          _buildSearchBar(),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.school_outlined, size: 64,
                            color: tx6.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text('學習庫是空的',
                            style: TextStyle(color: tx6, fontSize: 16, fontWeight: fw5)),
                        const SizedBox(height: 8),
                        Text('從 AI 回應中儲存知識到這裡',
                            style: TextStyle(color: tx6.withOpacity(0.6), fontSize: 13)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    itemBuilder: (_, i) => _buildCard(items[i]),
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
        left: 20, right: 20, bottom: 8,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu_rounded, color: tx1, size: 24),
          ),
          const SizedBox(width: 12),
          Text('學習庫', style: TextStyle(color: tx1, fontSize: 24, fontWeight: fw8)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: bg2, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
        ),
        child: TextField(
          style: TextStyle(color: tx1, fontSize: 14),
          cursorColor: primary,
          onChanged: (v) => setState(() => _searchQuery = v),
          decoration: InputDecoration(
            hintText: '搜尋學習筆記...',
            hintStyle: TextStyle(color: tx6.withOpacity(0.6), fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: tx6, size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(LearningItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bg2, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
      ),
      child: InkWell(
        onLongPress: () => _showDeleteDialog(item),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb_outline_rounded, size: 18, color: primary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item.title,
                      style: TextStyle(color: tx1, fontSize: 15, fontWeight: fw6),
                      maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
              const SizedBox(height: 8),
              Text(item.summary,
                  style: TextStyle(color: tx2, fontSize: 13, height: 1.5),
                  maxLines: 3, overflow: TextOverflow.ellipsis),
              if (item.tags.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6, runSpacing: 4,
                  children: item.tags.map((t) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(t,
                        style: TextStyle(color: primary, fontSize: 11, fontWeight: fw5)),
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(LearningItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: bg1_5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('刪除筆記？', style: TextStyle(color: tx1, fontWeight: fw7)),
        content: Text('確定要刪除「${item.title}」嗎？', style: TextStyle(color: tx2)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('取消', style: TextStyle(color: tx6)),
          ),
          TextButton(
            onPressed: () {
              widget.learningController.deleteItem(item.id);
              Navigator.pop(ctx);
            },
            child: Text('刪除', style: TextStyle(color: CommonColors.error)),
          ),
        ],
      ),
    );
  }
}
