import 'package:learnio/base.dart';
import 'package:learnio/script/controller/chat/project_controller.dart';
import 'package:learnio/script/types/project.dart' as model;

class ProjectPage extends StatefulWidget {
  final ProjectController projectController;
  final void Function(String conversationId) onOpenConversation;

  const ProjectPage({
    super.key,
    required this.projectController,
    required this.onOpenConversation,
  });

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  @override
  void initState() {
    super.initState();
    widget.projectController.onStateChanged = () {
      if (mounted) setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg1,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: widget.projectController.projects.isEmpty
                ? _buildEmptyState()
                : _buildProjectList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        backgroundColor: primary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderL),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + DesignSystem.space12,
        left: DesignSystem.space12,
        right: DesignSystem.space20,
        bottom: DesignSystem.space16,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu_rounded, color: tx1, size: 26),
          ),
          const SizedBox(width: DesignSystem.space8),
          Text('專案', style: tsTitleLarge.copyWith(fontSize: 24)),
        ],
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
            child: Icon(Icons.folder_open_rounded, size: 48, color: tx6.withOpacity(0.5)),
          ),
          const SizedBox(height: DesignSystem.space24),
          Text('還沒有任何專案', style: tsTitleMedium.copyWith(color: tx6)),
          const SizedBox(height: DesignSystem.space8),
          Text('建立專案來整理你的對話', style: tsBodyMedium.copyWith(color: tx6.withOpacity(0.6))),
        ],
      ),
    );
  }

  Widget _buildProjectList() {
    final projects = widget.projectController.projects;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.space20),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final proj = projects[index];
        return _buildProjectCard(proj);
      },
    );
  }

  Widget _buildProjectCard(model.Project proj) {
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
          HapticFeedback.lightImpact();
          if (proj.conversationIds.isNotEmpty) {
            widget.onOpenConversation(proj.conversationIds.first);
          }
        },
        onLongPress: () {
          HapticFeedback.mediumImpact();
          _showDeleteDialog(proj);
        },
        borderRadius: DesignSystem.borderM,
        child: Padding(
          padding: const EdgeInsets.all(DesignSystem.space16),
          child: Row(
            children: [
              // 色塊圖示
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: proj.color.withOpacity(0.1),
                  borderRadius: DesignSystem.borderM,
                ),
                child: Icon(
                  Icons.folder_rounded,
                  color: proj.color,
                  size: 26,
                ),
              ),
              const SizedBox(width: DesignSystem.space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(proj.name, style: tsTitleMedium.copyWith(fontSize: 16)),
                    if (proj.description.isNotEmpty) ...[
                      const SizedBox(height: DesignSystem.space4),
                      Text(
                        proj.description,
                        style: tsCaption.copyWith(fontSize: 13, color: tx6),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // 對話數量
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: bg3.withOpacity(0.3),
                  borderRadius: DesignSystem.borderS,
                ),
                child: Text(
                  '${proj.conversationCount}',
                  style: tsCaption.copyWith(fontWeight: fw7, color: tx2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: bg1_5,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderL),
        title: Text('建立專案', style: tsTitleMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(nameCtrl, '專案名稱', autofocus: true),
            const SizedBox(height: DesignSystem.space16),
            _buildTextField(descCtrl, '描述（選填）'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('取消', style: tsBodyMedium.copyWith(color: tx6)),
          ),
          TextButton(
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                widget.projectController.createProject(
                  name: nameCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                );
                Navigator.pop(ctx);
              }
            },
            child: Text('建立', style: tsBodyMedium.copyWith(color: primary, fontWeight: fw7)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint, {bool autofocus = false}) {
    return Container(
      decoration: BoxDecoration(
        color: bg2,
        borderRadius: DesignSystem.borderM,
        border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.space16),
      child: TextField(
        controller: ctrl,
        autofocus: autofocus,
        style: tsBodyMedium.copyWith(color: tx1),
        cursorColor: primary,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: tsBodyMedium.copyWith(color: tx6.withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  void _showDeleteDialog(model.Project proj) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: bg1_5,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderL),
        title: Text('刪除專案？', style: tsTitleLarge),
        content: Text('確定要刪除「${proj.name}」嗎？', style: tsBodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('取消', style: tsBodyMedium.copyWith(color: tx6)),
          ),
          TextButton(
            onPressed: () {
              widget.projectController.deleteProject(proj.id);
              Navigator.pop(ctx);
            },
            child: Text('刪除', style: tsBodyMedium.copyWith(color: CommonColors.error)),
          ),
        ],
      ),
    );
  }
}
