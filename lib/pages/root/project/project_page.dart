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
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu_rounded, color: tx1, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            '專案',
            style: TextStyle(
              color: tx1,
              fontSize: 24,
              fontWeight: fw8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.folder_open_rounded, size: 64, color: tx6.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            '還沒有任何專案',
            style: TextStyle(color: tx6, fontSize: 16, fontWeight: fw5),
          ),
          const SizedBox(height: 8),
          Text(
            '建立專案來整理你的對話',
            style: TextStyle(color: tx6.withOpacity(0.6), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectList() {
    final projects = widget.projectController.projects;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final proj = projects[index];
        return _buildProjectCard(proj);
      },
    );
  }

  Widget _buildProjectCard(model.Project proj) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bg2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
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
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 色塊圖示
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: proj.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.folder_rounded,
                  color: proj.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      proj.name,
                      style: TextStyle(
                        color: tx1,
                        fontSize: 16,
                        fontWeight: fw6,
                      ),
                    ),
                    if (proj.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        proj.description,
                        style: TextStyle(
                          color: tx6,
                          fontSize: 13,
                          fontWeight: fw4,
                        ),
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
                  color: bg3.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${proj.conversationCount}',
                  style: TextStyle(
                    color: tx6,
                    fontSize: 12,
                    fontWeight: fw6,
                  ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('建立專案', style: TextStyle(color: tx1, fontWeight: fw7)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: TextStyle(color: tx1),
              cursorColor: primary,
              decoration: InputDecoration(
                hintText: '專案名稱',
                hintStyle: TextStyle(color: tx6),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: bg3),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primary),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              style: TextStyle(color: tx1),
              cursorColor: primary,
              decoration: InputDecoration(
                hintText: '描述（選填）',
                hintStyle: TextStyle(color: tx6),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: bg3),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primary),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('取消', style: TextStyle(color: tx6)),
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
            child: Text('建立', style: TextStyle(color: primary)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(model.Project proj) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: bg1_5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('刪除專案？', style: TextStyle(color: tx1, fontWeight: fw7)),
        content: Text('確定要刪除「${proj.name}」嗎？',
            style: TextStyle(color: tx2)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('取消', style: TextStyle(color: tx6)),
          ),
          TextButton(
            onPressed: () {
              widget.projectController.deleteProject(proj.id);
              Navigator.pop(ctx);
            },
            child: Text('刪除',
                style: TextStyle(color: CommonColors.error)),
          ),
        ],
      ),
    );
  }
}
