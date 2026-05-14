import 'package:learnio/base.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = darkMode;
  bool _hapticEnabled = true;
  final String _language = '繁體中文';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg1,
      body: column([
        _buildHeader(context),
        expand(
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: DesignSystem.space20),
            children: [
                _buildSection('外觀', [
                  _toggleTile(
                    iconData: Icons.dark_mode_rounded,
                    title: '深色模式',
                    value: _isDarkMode,
                    onChanged: (v) {
                      setState(() => _isDarkMode = v);
                      darkMode = v;
                      rebuild('main');
                    },
                  ),
                  _toggleTile(
                    iconData: Icons.vibration_rounded,
                    title: '觸覺反饋',
                    value: _hapticEnabled,
                    onChanged: (v) => setState(() => _hapticEnabled = v),
                  ),
                ]),

                const SizedBox(height: DesignSystem.space24),
                _buildSection('一般', [
                  _navTile(
                    iconData: Icons.language_rounded,
                    title: '語言',
                    subtitle: _language,
                    onTap: () {},
                  ),
                  _navTile(
                    iconData: Icons.auto_awesome,
                    title: '預設模型',
                    subtitle: 'Gemini 2.5 Pro',
                    onTap: () {},
                  ),
                ]),

                const SizedBox(height: DesignSystem.space24),
                _buildSection('資料', [
                  _navTile(
                    iconData: Icons.download_rounded,
                    title: '匯出對話記錄',
                    onTap: () {},
                  ),
                  _navTile(
                    iconData: Icons.delete_outline_rounded,
                    title: '清除所有資料',
                    titleColor: CommonColors.error,
                    onTap: () {},
                  ),
                ]),

                _buildSection('關於', [
                  _navTile(
                    iconData: Icons.info_outline_rounded,
                    title: '版本',
                    subtitle: System.version,
                    onTap: () {},
                  ),
                  _navTile(
                    iconData: Icons.code_rounded,
                    title: '開發者',
                    subtitle: 'PCET_CHIENAN0617',
                    onTap: () {},
                  ),
                ]),

                height(48),
              ],
            ),
          ),
        ]),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return container(
      row([
        iconButton(
          icon(Icons.menu_outlined, 26, tx1),
          () => Scaffold.of(context).openDrawer(),
        ),
        width(DesignSystem.space8),
        text('設定', 24, fw7),
      ]),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + DesignSystem.space12,
        left: DesignSystem.space12,
        right: DesignSystem.space20,
        bottom: DesignSystem.space16,
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return column(
      [
        padding(
          const EdgeInsets.only(left: 4, bottom: DesignSystem.space12),
          text(
            '外觀與介面',
            14,
            fw7,
            tx6,
            false,
            null,
            fsN,
            TextAlign.start,
            null,
            TextOverflow.clip,
            1.2,
          ),
        ),
        container(
          column(
            List.generate(children.length, (index) {
              return column(
                [
                  children[index],
                  if (index < children.length - 1)
                    Divider(
                        height: 1,
                        thickness: 0.5,
                        color: bg3.withOpacity(0.3),
                        indent: 56),
                ],
              );
            }),
          ),
          color: bg2,
          radius: DesignSystem.borderM,
          border: Border.all(color: bg3.withOpacity(0.3), width: 0.5),
          shadow: DesignSystem.shadowSoft,
        ),
      ],
      ca: CrossAxisAlignment.start,
    );
  }

  Widget _toggleTile({
    required IconData iconData,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: icon(iconData, 22, tx2),
      title: text(title, 14, fw6, tx1),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: primary,
      ),
      contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.space16, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderM),
    );
  }

  Widget _navTile({
    required IconData iconData,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: icon(iconData, 22, titleColor ?? tx2),
      title: text(title, 14, fw6, titleColor ?? tx1),
      trailing: row(
        [
          if (subtitle != null) text(subtitle, 12, fw4, tx6),
          width(DesignSystem.space8),
          icon(Icons.chevron_right_rounded, 20, tx6),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.space16, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: DesignSystem.borderM),
    );
  }
}
