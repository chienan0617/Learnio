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
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bg2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: bg3.withOpacity(0.5), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, size: 14, color: primary),
            const SizedBox(width: 6),
            Text(
              chatController.selectedModel,
              style: TextStyle(
                color: tx2,
                fontSize: 13,
                fontWeight: fw5,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: tx6),
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
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: bg1_5,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 拖動指示器
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: bg4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  '選擇模型',
                  style: TextStyle(
                    color: tx1,
                    fontSize: 18,
                    fontWeight: fw7,
                  ),
                ),
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
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [primary, secondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected ? null : bg3,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      size: 18,
                      color: isSelected ? Colors.white : tx6,
                    ),
                  ),
                  title: Text(
                    model,
                    style: TextStyle(
                      color: isSelected ? tx1 : tx2,
                      fontSize: 15,
                      fontWeight: isSelected ? fw6 : fw4,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle_rounded,
                          color: primary, size: 20)
                      : null,
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
