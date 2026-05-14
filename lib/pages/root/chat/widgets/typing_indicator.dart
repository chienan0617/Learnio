import 'package:learnio/base.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (i) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });

    _animations = _controllers.map((c) {
      return Tween<double>(
        begin: 0,
        end: -6,
      ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));
    }).toList();

    // 錯開動畫啟動時間
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 180), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return padding(
      const EdgeInsets.only(
        left: DesignSystem.space12,
        right: DesignSystem.space32,
        top: DesignSystem.space8,
        bottom: DesignSystem.space8,
      ),
      column([
        // AI 標籤
        padding(
          const EdgeInsets.only(
              bottom: DesignSystem.space8, left: DesignSystem.space4),
          row([
            _buildAvatar(),
            width(DesignSystem.space8),
            text(
              'Learnio',
              12,
              fw7,
            ),
          ]),
        ),

        // 打字指示器氣泡
        container(
          row(List.generate(3, (i) {
            return AnimatedBuilder(
              animation: _animations[i],
              builder: (_, __) => Transform.translate(
                offset: Offset(0, _animations[i].value),
                child: container(
                  const SizedBox.shrink(),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 6,
                  height: 6,
                  color: primary.withOpacity(0.4 + i * 0.2),
                  shape: BoxShape.circle,
                ),
              ),
            );
          })),
          padding: const EdgeInsets.symmetric(
              horizontal: DesignSystem.space20, vertical: DesignSystem.space16),
          color: bg2,
          radius: BorderRadius.only(
            topLeft: Radius.zero,
            topRight: DesignSystem.borderL.topRight,
            bottomLeft: DesignSystem.borderL.bottomLeft,
            bottomRight: DesignSystem.borderL.bottomRight,
          ),
          border: Border.all(color: bg3.withOpacity(0.4), width: 0.5),
        ),
      ]),
    );
  }

  Widget _buildAvatar() {
    return container(
      logo(16, Colors.white),
      width: 32,

      height: 28,
      gradient: LinearGradient(
        colors: [primary, secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      radius: DesignSystem.borderS,
    );
  }
}
