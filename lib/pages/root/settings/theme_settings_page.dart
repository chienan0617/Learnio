import 'package:learnio/base.dart';

class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg1,
      appBar: AppBar(
        backgroundColor: transparent,
        elevation: 0,
        leading: iconButton(icon(Icons.arrow_back_ios_new_rounded, 20, tx1), () => popPage(context)),
        title: text('主題設定', 18, fw7),
        centerTitle: true,
      ),
      body: scroll(
        padding(
          const EdgeInsets.all(DesignSystem.space20),
          column([
            text('外觀模式', 14, fw7, tx6),
            height(DesignSystem.space16),
            
            row([
              expand(_buildThemeCard(
                title: '淺色模式',
                isDark: false,
                isSelected: !darkMode,
                accentColor: const Color(0xFF60A5FA),
                surfaceColor: const Color(0xFFF4F6FA),
              )),
              width(DesignSystem.space16),
              expand(_buildThemeCard(
                title: '深色模式',
                isDark: true,
                isSelected: darkMode,
                accentColor: const Color(0xFF2563EB),
                surfaceColor: const Color(0xFF09090B),
              )),
            ]),
            
            height(DesignSystem.space32),
            text('其他選項', 14, fw7, tx6),
            height(DesignSystem.space12),
            
            container(
              _buildSettingTile(
                iconData: Icons.brightness_auto_rounded,
                title: '跟隨系統設定',
                trailing: Switch.adaptive(
                  value: false, // TODO: 實作系統追隨邏輯
                  onChanged: (v) {},
                  activeColor: primary,
                ),
              ),
              color: bg2,
              radius: DesignSystem.borderM,
              border: Border.all(color: bg3.withOpacity(0.3), width: 0.5),
            ),
            
            height(DesignSystem.space24),
            padding(
              const EdgeInsets.symmetric(horizontal: 4),
              text('選擇深色模式可減少螢幕耗電並在低光環境下提供更舒適的閱讀體驗。', 13, fw4, tx6),
            ),
          ], ca: caS),
        ),
      ),
    );
  }

  Widget _buildThemeCard({
    required String title,
    required bool isDark,
    required bool isSelected,
    required Color accentColor,
    required Color surfaceColor,
  }) {
    return inkWell(
      container(
        column([
          // Preview Area
          expand(
            container(
              stack([
                // Mock UI Elements
                positioned(
                  container(box(), width: 40, height: 6, radius: borderCircular(3), color: accentColor.withOpacity(0.4)),
                  t: 12, l: 12,
                ),
                positioned(
                  container(box(), width: 24, height: 6, radius: borderCircular(3), color: tx6.withOpacity(0.2)),
                  t: 12, r: 12,
                ),
                center(
                  column([
                    container(box(), width: 60, height: 8, radius: borderCircular(4), color: tx6.withOpacity(0.3)),
                    height(6),
                    container(box(), width: 40, height: 8, radius: borderCircular(4), color: tx6.withOpacity(0.1)),
                  ]),
                ),
                positioned(
                  container(
                    center(icon(Icons.send_rounded, 10, Colors.white)),
                    width: 24, height: 24, shape: BoxShape.circle, color: accentColor,
                  ),
                  b: 12, r: 12,
                ),
              ]),
              width: double.infinity,
              color: surfaceColor,
              radius: DesignSystem.borderS,
              border: isSelected ? Border.all(color: primary, width: 2) : Border.all(color: bg3.withOpacity(0.2), width: 1),
            ),
          ),
          height(DesignSystem.space12),
          // Label
          row([
            text(title, 14, isSelected ? fw7 : fw5, isSelected ? primary : tx1),
            const Spacer(),
            if (isSelected) icon(Icons.check_circle_rounded, 18, primary),
          ]),
          height(DesignSystem.space12),
        ]),
        padding: const EdgeInsets.all(DesignSystem.space8),
        height: 160,
        color: bg2,
        radius: DesignSystem.borderM,
        border: Border.all(color: isSelected ? primary.withOpacity(0.5) : bg3.withOpacity(0.3), width: isSelected ? 1.5 : 0.5),
        shadow: isSelected ? [BoxShadow(color: primary.withOpacity(0.1), blurRadius: 10, spreadRadius: 2)] : DesignSystem.shadowSoft,
      ),
      () {
        if (darkMode != isDark) {
          HapticFeedback.mediumImpact();
          darkMode = isDark;
          rebuild('main');
          setState(() {});
        }
      },
    );
  }

  Widget _buildSettingTile({
    required IconData iconData,
    required String title,
    required Widget trailing,
  }) {
    return padding(
      const EdgeInsets.symmetric(horizontal: DesignSystem.space16, vertical: 12),
      row([
        icon(iconData, 22, tx2),
        width(DesignSystem.space12),
        expand(text(title, 14, fw6, tx1)),
        trailing,
      ]),
    );
  }
}
