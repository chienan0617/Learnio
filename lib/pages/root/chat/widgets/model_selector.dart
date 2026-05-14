import 'package:learnio/base.dart';
import 'package:learnio/script/controller/chat/chat_controller.dart';

class ModelSelector extends StatelessWidget {
  final ChatController chatController;
  final VoidCallback onChanged;

  const ModelSelector({
    super.key,
    required this.chatController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return inkWell(
      container(
        row([
          icon(Icons.star, 14, primary),
          width(DesignSystem.space4),
          text(chatController.selectedModel, 13, fw6, tx2),
          width(DesignSystem.space4),
          icon(Icons.keyboard_arrow_down_rounded, 16, tx6),
        ]),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.space8,
          vertical: DesignSystem.space4,
        ),
        color: bg3.withOpacity(0.3),
        radius: DesignSystem.borderM,
      ),
      () => _showModelPicker(context),
      radius: DesignSystem.borderM,
    );
  }

  void _showModelPicker(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => container(
        SafeArea(
          child: column([
            // 拖動指示器
            container(
              const SizedBox.shrink(),
              margin: const EdgeInsets.only(top: DesignSystem.space12),
              width: 36,
              height: 4,
              color: bg4,
              radius: BorderRadius.circular(2),
            ),
            padding(
              const EdgeInsets.all(DesignSystem.space24),
              text('選擇模型', 16, fw6),
            ),
            ...ChatController.availableModels.map((model) {
              final isSelected = model == chatController.selectedModel;
              return ListTile(
                onTap: () {
                  HapticFeedback.lightImpact();
                  chatController.selectModel(model);
                  onChanged();
                  Navigator.pop(ctx);
                },
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: DesignSystem.space24,
                  vertical: DesignSystem.space4,
                ),
                leading: container(
                  icon(Icons.auto_awesome, 20, isSelected ? Colors.white : tx6),
                  width: 40,
                  height: 40,
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [primary, secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : bg3.withOpacity(0.5),
                  radius: DesignSystem.borderM,
                ),
                title: text(
                  model,
                  14,
                  isSelected ? fw7 : fw4,
                  isSelected ? tx1 : tx2,
                ),
                trailing: isSelected
                    ? icon(Icons.check_circle_rounded, 22, primary)
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: DesignSystem.borderM,
                ),
              );
            }),
            height(DesignSystem.space24),
          ]),
        ),
        color: bg1_5,
        radius: const BorderRadius.vertical(
          top: Radius.circular(DesignSystem.radiusXL),
        ),
      ),
    );
  }
}
