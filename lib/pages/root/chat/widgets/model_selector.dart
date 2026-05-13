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
    return InkWell(
      onTap: () => _showModelPicker(context),
      borderRadius: DesignSystem.borderXL,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.space12, vertical: DesignSystem.space8),
        decoration: BoxDecoration(
          color: bg2,
          borderRadius: DesignSystem.borderXL,
          border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, size: 14, color: primary),
            const SizedBox(width: DesignSystem.space8),
            Text(
              chatController.selectedModel,
              style: tsBodyMedium.copyWith(fontWeight: fw6, color: tx1),
            ),
            const SizedBox(width: DesignSystem.space4),
            Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: tx6),
          ],
        ),
      ),
    );
  }

  void _showModelPicker(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: bg1_5,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(DesignSystem.radiusXL)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 拖動指示器
              Container(
                margin: const EdgeInsets.only(top: DesignSystem.space12),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: bg4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(DesignSystem.space24),
                child: Text('選擇模型', style: tsTitleMedium),
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
                      horizontal: DesignSystem.space24, vertical: DesignSystem.space4),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [primary, secondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected ? null : bg3.withOpacity(0.5),
                      borderRadius: DesignSystem.borderM,
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      size: 20,
                      color: isSelected ? Colors.white : tx6,
                    ),
                  ),
                  title: Text(
                    model,
                    style: tsBodyMedium.copyWith(
                      color: isSelected ? tx1 : tx2,
                      fontWeight: isSelected ? fw7 : fw4,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: primary,
                          size: 22,
                        )
                      : null,
                  shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderM),
                );
              }),
              const SizedBox(height: DesignSystem.space24),
            ],
          ),
        ),
      ),
    );
  }
}
