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
      body: column([
        _buildHeader(context),
        _buildSearchBar(),
        expand(
          items.isEmpty ? _buildEmptyState() : _buildLearningList(items),
        ),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return container(
      row([
        iconButton(
          icon(Icons.menu_rounded, 26, tx1),
          () => Scaffold.of(context).openDrawer(),
        ),
        width(DesignSystem.space8),
        text('學習庫', 24, fw7),
      ]),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + DesignSystem.space12,
        left: DesignSystem.space12,
        right: DesignSystem.space20,
        bottom: DesignSystem.space8,
      ),
    );
  }

  Widget _buildSearchBar() {
    return padding(
      const EdgeInsets.symmetric(
          horizontal: DesignSystem.space20, vertical: DesignSystem.space12),
      container(
        TextField(
          style: tsBodyMedium.copyWith(color: tx1),
          cursorColor: primary,
          onChanged: (v) => setState(() => _searchQuery = v),
          decoration: InputDecoration(
            hintText: '搜尋學習筆記...',
            hintStyle: tsBodyMedium.copyWith(color: tx6.withOpacity(0.5)),
            prefixIcon: icon(Icons.search_outlined, 20, tx6),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        color: bg2,
        radius: DesignSystem.borderXL,
        border: Border.all(color: bg3.withOpacity(0.4), width: 0.5),
      ),
    );
  }

  Widget _buildEmptyState() {
    return center(
      column(
        [
          container(
            icon(Icons.school_outlined, 48, tx6.withOpacity(0.3)),
            padding: symmetricAll(DesignSystem.space24),
            color: bg2,
            shape: BoxShape.circle,
          ),
          height(DesignSystem.space24),
          text('學習庫是空的', 18, fw7, tx6),
          height(DesignSystem.space8),
          text('從 AI 回應中儲存知識到這裡', 14, fw4, tx6.withOpacity(0.6)),
        ],
        ma: MainAxisAlignment.center,
        ca: CrossAxisAlignment.center,
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
    return container(
      inkWell(
        padding(
          const EdgeInsets.all(DesignSystem.space16),
          column([
            row([
              container(
                icon(Icons.lightbulb_outline_rounded, 16, primary),
                padding: const EdgeInsets.all(6),
                color: primary.withOpacity(0.1),
                radius: DesignSystem.borderS,
              ),
              width(DesignSystem.space12),
              expand(
                text(
                  item.title,
                  16,
                  fw6,
                  null,
                  false,
                  null,
                  fsN,
                  TextAlign.start,
                  1,
                  TextOverflow.ellipsis,
                ),
              ),
            ]),
            height(DesignSystem.space12),
            text(
              item.summary,
              14,
              fw4,
              tx2,
              false,
              null,
              fsN,
              TextAlign.start,
              3,
              TextOverflow.ellipsis,
            ),
            if (item.tags.isNotEmpty) ...[
              height(DesignSystem.space16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: item.tags.map((t) => _buildTag(t)).toList(),
              ),
            ],
          ]),
        ),
        () {
          // TODO: 查看詳情
        },
        onLongPress: () => _showDeleteDialog(item),
        radius: DesignSystem.borderM,
      ),
      margin: const EdgeInsets.only(bottom: DesignSystem.space16),
      color: bg2,
      radius: DesignSystem.borderM,
      border: Border.all(color: bg3.withOpacity(0.4), width: 0.5),
      shadow: DesignSystem.shadowSoft,
    );
  }

  Widget _buildTag(String tag) {
    return container(
      text(
        tag,
        11,
        fw7,
        primary,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      color: primary.withOpacity(0.08),
      radius: DesignSystem.borderS,
      border: Border.all(color: primary.withOpacity(0.2), width: 0.5),
    );
  }

  void _showDeleteDialog(LearningItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: bg1_5,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderL),
        title: text('刪除筆記？', 22, fw7),
        content: text('確定要刪除「${item.title}」嗎？', 14, fw4, tx2),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: text('取消', 14, fw4, tx6),
          ),
          TextButton(
            onPressed: () {
              widget.learningController.deleteItem(item.id);
              Navigator.pop(ctx);
            },
            child: text('刪除', 14, fw4, CommonColors.error),
          ),
        ],
      ),
    );
  }
}
