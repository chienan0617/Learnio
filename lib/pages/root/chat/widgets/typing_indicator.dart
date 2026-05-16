import 'package:learnio/base.dart';
import 'dart:ui' as ui;

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
        begin: 0.2,
        end: 1.0,
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
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: AnimationController(
          duration: const Duration(milliseconds: 500),
          vsync: this,
        )..forward(),
        curve: Curves.easeIn,
      ),
      child: padding(
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
              bottom: DesignSystem.space8,
              left: DesignSystem.space4,
            ),
            row([
              _buildAvatar(),
              width(DesignSystem.space8),
              text('Learnio', 12, fw7, tx6),
            ]),
          ),

          // 打字指示器氣泡 (Glassmorphism)
          ClipRRect(
            borderRadius: DesignSystem.borderXL,
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: container(
                row(
                  List.generate(3, (i) {
                    return AnimatedBuilder(
                      animation: _animations[i],
                      builder: (_, __) {
                        final val = _animations[i].value;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                primary.withOpacity(0.4 + val * 0.6),
                                primary.withOpacity(0),
                              ],
                              stops: const [0.6, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withOpacity(0.3 * val),
                                blurRadius: 4 * val,
                                spreadRadius: 1 * val,
                              ),
                            ],
                          ),
                          child: const SizedBox.shrink(),
                        );
                      },
                    );
                  }),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignSystem.space20,
                  vertical: DesignSystem.space16,
                ),
                color: bg2.withOpacity(0.7),
                border: Border.all(color: bg3.withOpacity(0.3), width: 0.5),
              ),
            ),
          ),
        ]),
      ),
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
