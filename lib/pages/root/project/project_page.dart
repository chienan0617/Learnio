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
      body: column([
        _buildHeader(context),
        expand(
          widget.projectController.projects.isEmpty
              ? _buildEmptyState()
              : _buildProjectList(),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        backgroundColor: primary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderL),
        child: icon(Icons.add_rounded, 28, Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return container(
      row([
        iconButton(
          icon(Icons.menu_rounded, 26, tx1),
          () {
            HapticFeedback.lightImpact();
            Scaffold.of(context).openDrawer();
          },
        ),
        width(DesignSystem.space8),
        text('專案', 24, fw7),
      ]),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + DesignSystem.space12,
        left: DesignSystem.space12,
        right: DesignSystem.space20,
        bottom: DesignSystem.space16,
      ),
    );
  }

  Widget _buildEmptyState() {
    return center(
      column(
        [
          container(
            icon(Icons.folder_open_outlined, 48, tx6.withOpacity(0.5)),
            padding: symmetricAll(DesignSystem.space24),
            color: bg2,
            shape: BoxShape.circle,
          ),
          height(DesignSystem.space24),
          text('還沒有任何專案', 18, fw7, tx6),
          height(DesignSystem.space8),
          text('建立專案來整理你的對話', 14, fw4, tx6.withOpacity(0.6)),
        ],
        ma: MainAxisAlignment.center,
        ca: CrossAxisAlignment.center,
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
    return container(
      inkWell(
        padding(
          const EdgeInsets.all(DesignSystem.space16),
          row([
            // 色塊圖示
            container(
              icon(Icons.folder_rounded, 26, proj.color),
              width: 52,
              height: 52,
              color: proj.color.withOpacity(0.1),
              radius: DesignSystem.borderM,
            ),
            width(DesignSystem.space16),
            expand(
              column(
                [
                  text(proj.name, 16, fw6),
                  if (proj.description.isNotEmpty) ...[
                    height(DesignSystem.space4),
                    text(
                      proj.description,
                      13,
                      fw4,
                      tx6,
                      false,
                      null,
                      fsN,
                      TextAlign.start,
                      1,
                      TextOverflow.ellipsis,
                    ),
                  ],
                ],
                ca: CrossAxisAlignment.start,
              ),
            ),
            // 對話數量
            container(
              text(
                '${proj.conversationCount}',
                12,
                fw7,
                tx2,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              color: bg3.withOpacity(0.3),
              radius: DesignSystem.borderS,
            ),
          ]),
        ),
        () {
          HapticFeedback.lightImpact();
          if (proj.conversationIds.isNotEmpty) {
            widget.onOpenConversation(proj.conversationIds.first);
          }
        },
        onLongPress: () {
          HapticFeedback.mediumImpact();
          _showDeleteDialog(proj);
        },
        radius: DesignSystem.borderM,
      ),
      margin: const EdgeInsets.only(bottom: DesignSystem.space16),
      color: bg2,
      radius: DesignSystem.borderM,
      border: Border.all(color: bg3.withOpacity(0.4), width: 0.5),
      shadow: DesignSystem.shadowSoft,
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
        title: text('建立專案', 18, fw7),
        content: column([
          _buildTextField(nameCtrl, '專案名稱', autofocus: true),
          height(DesignSystem.space16),
          _buildTextField(descCtrl, '描述（選填）'),
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: text('取消', 14, fw4, tx6),
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
            child: text('建立', 14, fw7, primary),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint,
      {bool autofocus = false}) {
    return container(
      TextField(
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
      color: bg2,
      radius: DesignSystem.borderM,
      border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.space16),
    );
  }

  void _showDeleteDialog(model.Project proj) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: bg1_5,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderL),
        title: text('刪除專案？', 22, fw7),
        content: text('確定要刪除「${proj.name}」嗎？', 14, fw4, tx2),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: text('取消', 14, fw4, tx6),
          ),
          TextButton(
            onPressed: () {
              widget.projectController.deleteProject(proj.id);
              Navigator.pop(ctx);
            },
            child: text('刪除', 14, fw4, CommonColors.error),
          ),
        ],
      ),
    );
  }
}
