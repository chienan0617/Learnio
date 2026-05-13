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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _sectionTitle('外觀'),
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

                const SizedBox(height: 16),
                _sectionTitle('一般'),
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

                const SizedBox(height: 16),
                _sectionTitle('資料'),
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

                const SizedBox(height: 16),
                _sectionTitle('關於'),
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

                const SizedBox(height: 32),
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
        top: MediaQuery.of(context).padding.top + 12,
        left: 20, right: 20, bottom: 16,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu_rounded, color: tx1, size: 24),
          ),
          const SizedBox(width: 12),
          Text('設定', style: TextStyle(color: tx1, fontSize: 24, fontWeight: fw8)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 8, bottom: 8),
      child: Text(title,
          style: TextStyle(color: tx6, fontSize: 13, fontWeight: fw6,
              letterSpacing: 0.5)),
    );
  }

  Widget _toggleTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: bg2, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: bg3.withOpacity(0.3), width: 0.5),
      ),
      child: ListTile(
        leading: Icon(icon, color: tx2, size: 22),
        title: Text(title, style: TextStyle(color: tx1, fontSize: 15, fontWeight: fw5)),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: primary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _navTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: bg2, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: bg3.withOpacity(0.3), width: 0.5),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: titleColor ?? tx2, size: 22),
        title: Text(title,
            style: TextStyle(color: titleColor ?? tx1, fontSize: 15, fontWeight: fw5)),
        trailing: subtitle != null
            ? Text(subtitle, style: TextStyle(color: tx6, fontSize: 13))
            : Icon(Icons.chevron_right_rounded, color: tx6, size: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
