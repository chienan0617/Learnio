import 'package:learnio/base.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = darkMode;
  bool _hapticEnabled = true;
  String _language = '繁體中文';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg1,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: DesignSystem.space20),
              children: [
                _buildSection('外觀', [
                  _toggleTile(
                    icon: Icons.dark_mode_rounded,
                    title: '深色模式',
                    value: _isDarkMode,
                    onChanged: (v) {
                      setState(() => _isDarkMode = v);
                      // darkMode = v;
                    },
                  ),
                  _toggleTile(
                    icon: Icons.vibration_rounded,
                    title: '觸覺反饋',
                    value: _hapticEnabled,
                    onChanged: (v) => setState(() => _hapticEnabled = v),
                  ),
                ]),

                const SizedBox(height: DesignSystem.space24),
                _buildSection('一般', [
                  _navTile(
                    icon: Icons.language_rounded,
                    title: '語言',
                    subtitle: _language,
                    onTap: () {},
                  ),
                  _navTile(
                    icon: Icons.auto_awesome,
                    title: '預設模型',
                    subtitle: 'Gemini 2.5 Pro',
                    onTap: () {},
                  ),
                ]),

                const SizedBox(height: DesignSystem.space24),
                _buildSection('資料', [
                  _navTile(
                    icon: Icons.download_rounded,
                    title: '匯出對話記錄',
                    onTap: () {},
                  ),
                  _navTile(
                    icon: Icons.delete_outline_rounded,
                    title: '清除所有資料',
                    titleColor: CommonColors.error,
                    onTap: () {},
                  ),
                ]),

                const SizedBox(height: DesignSystem.space24),
                _buildSection('關於', [
                  _navTile(
                    icon: Icons.info_outline_rounded,
                    title: '版本',
                    subtitle: System.version,
                    onTap: () {},
                  ),
                  _navTile(
                    icon: Icons.code_rounded,
                    title: '開發者',
                    subtitle: 'PCET_CHIENAN0617',
                    onTap: () {},
                  ),
                ]),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
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
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu_rounded, color: tx1, size: 26),
          ),
          const SizedBox(width: DesignSystem.space8),
          Text('設定', style: tsTitleLarge.copyWith(fontSize: 24)),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: DesignSystem.space12),
          child: Text(
            title,
            style: tsCaption.copyWith(fontWeight: fw7, letterSpacing: 1.0, color: tx6),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: bg2,
            borderRadius: DesignSystem.borderM,
            border: Border.all(color: bg3.withOpacity(0.3), width: 0.5),
            boxShadow: DesignSystem.shadowSoft,
          ),
          child: Column(
            children: List.generate(children.length, (index) {
              return Column(
                children: [
                  children[index],
                  if (index < children.length - 1)
                    Divider(height: 1, thickness: 0.5, color: bg3.withOpacity(0.3), indent: 56),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _toggleTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: tx2, size: 22),
      title: Text(title, style: tsBodyMedium.copyWith(color: tx1, fontWeight: fw6)),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: primary,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: DesignSystem.space16, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderM),
    );
  }

  Widget _navTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: titleColor ?? tx2, size: 22),
      title: Text(title,
          style: tsBodyMedium.copyWith(color: titleColor ?? tx1, fontWeight: fw6)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (subtitle != null)
            Text(subtitle, style: tsCaption.copyWith(color: tx6)),
          const SizedBox(width: DesignSystem.space8),
          Icon(Icons.chevron_right_rounded, color: tx6, size: 20),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: DesignSystem.space16, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderM),
    );
  }
}
