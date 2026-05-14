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
                ? _buildEmptyState()
                : _buildLearningList(items),
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
        bottom: DesignSystem.space8,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu_rounded, color: tx1, size: 26),
          ),
          const SizedBox(width: DesignSystem.space8),
          Text('學習庫', style: tsTitleLarge.copyWith(fontSize: 24)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.space20, vertical: DesignSystem.space12),
      child: Container(
        decoration: BoxDecoration(
          color: bg2,
          borderRadius: DesignSystem.borderXL,
          border: Border.all(color: bg3.withOpacity(0.4), width: 0.5),
        ),
        child: TextField(
          style: tsBodyMedium.copyWith(color: tx1),
          cursorColor: primary,
          onChanged: (v) => setState(() => _searchQuery = v),
          decoration: InputDecoration(
            hintText: '搜尋學習筆記...',
            hintStyle: tsBodyMedium.copyWith(color: tx6.withOpacity(0.5)),
            prefixIcon: Icon(Icons.search_outlined, color: tx6, size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
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
            child: Icon(Icons.school_outlined, size: 48, color: tx6.withOpacity(0.3)),
          ),
          const SizedBox(height: DesignSystem.space24),
          Text('學習庫是空的', style: tsTitleMedium.copyWith(color: tx6)),
          const SizedBox(height: DesignSystem.space8),
          Text('從 AI 回應中儲存知識到這裡', style: tsBodyMedium.copyWith(color: tx6.withOpacity(0.6))),
        ],
      ),
    );
  }

  Widget _buildLearningList(List<LearningItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.space20),
      itemCount: items.length,
      itemBuilder: (_, i) => _buildCard(items[i]),
    );
  }

  Widget _buildCard(LearningItem item) {
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
          // TODO: 查看詳情
        },
        onLongPress: () => _showDeleteDialog(item),
        borderRadius: DesignSystem.borderM,
        child: Padding(
          padding: const EdgeInsets.all(DesignSystem.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: DesignSystem.borderS,
                    ),
                    child: Icon(Icons.lightbulb_outline_rounded, size: 16, color: primary),
                  ),
                  const SizedBox(width: DesignSystem.space12),
                  Expanded(
                    child: Text(
                      item.title,
                      style: tsTitleMedium.copyWith(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignSystem.space12),
              Text(
                item.summary,
                style: tsBodyMedium.copyWith(color: tx2, height: 1.6),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (item.tags.isNotEmpty) ...[
                const SizedBox(height: DesignSystem.space16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: item.tags.map((t) => _buildTag(t)).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.08),
        borderRadius: DesignSystem.borderS,
        border: Border.all(color: primary.withOpacity(0.2), width: 0.5),
      ),
      child: Text(
        tag,
        style: tsCaption.copyWith(color: primary, fontWeight: fw7, fontSize: 11),
      ),
    );
  }

  void _showDeleteDialog(LearningItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: bg1_5,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderL),
        title: Text('刪除筆記？', style: tsTitleLarge),
        content: Text('確定要刪除「${item.title}」嗎？', style: tsBodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('取消', style: tsBodyMedium.copyWith(color: tx6)),
          ),
          TextButton(
            onPressed: () {
              widget.learningController.deleteItem(item.id);
              Navigator.pop(ctx);
            },
            child: Text('刪除', style: tsBodyMedium.copyWith(color: CommonColors.error)),
          ),
        ],
      ),
    );
  }
}
