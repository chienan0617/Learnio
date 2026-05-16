import 'package:learnio/base.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg1,
      body: column([
        _buildHeader(context),
        expand(
          ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignSystem.space20,
            ),
            children: [
              _buildProfileHeader(),
              const SizedBox(height: DesignSystem.space24),
              _buildSection('基本資訊', [
                _infoTile(
                  iconData: Icons.badge_outlined,
                  label: '使用者名稱',
                  value: 'Premium User',
                ),
                _infoTile(
                  iconData: Icons.email_outlined,
                  label: '電子郵件',
                  value: 'user@learnio.ai',
                ),
                _infoTile(
                  iconData: Icons.verified_user_outlined,
                  label: '帳號狀態',
                  value: 'Premium',
                  valueColor: primary,
                ),
              ]),
              const SizedBox(height: DesignSystem.space24),
              _buildSection('使用數據', [
                _infoTile(
                  iconData: Icons.chat_bubble_outline_rounded,
                  label: '總對話次數',
                  value: '128',
                ),
                _infoTile(
                  iconData: Icons.bookmark_outline_rounded,
                  label: '收藏項目',
                  value: '42',
                ),
              ]),
              const SizedBox(height: DesignSystem.space32),
              _buildActionButton(
                '登出帳號',
                Icons.logout_rounded,
                CommonColors.error,
                () {
                  AuthController.instance.logout();
                  Navigator.pop(context);
                },
              ),
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
        text('個人資訊', 24, fw7),
      ]),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + DesignSystem.space12,
        left: DesignSystem.space12,
        right: DesignSystem.space20,
        bottom: DesignSystem.space16,
      ),
    );
  }

  Widget _buildProfileHeader() {
    return container(
      column([
        container(
          icon(Icons.person_rounded, 48, Colors.white),
          width: 80,
          height: 80,
          gradient: LinearGradient(
            colors: [primary, secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          shadow: [
            BoxShadow(
              color: primary.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        height(DesignSystem.space16),
        text('Premium User', 20, fw7),
        height(DesignSystem.space4),
        container(
          text('PREMIUM', 10, fw7, Colors.white),
          padding: symmetric(8, 4),
          color: primary,
          radius: DesignSystem.borderS,
        ),
      ]),
      padding: symmetricV(DesignSystem.space20),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return column([
      padding(
        const EdgeInsets.only(left: 4, bottom: DesignSystem.space12),
        text(title, 14, fw7, tx6),
      ),
      container(
        column(
          List.generate(children.length, (index) {
            return column([
              children[index],
              if (index < children.length - 1)
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: bg3.withOpacity(0.3),
                  indent: 56,
                ),
            ]);
          }),
        ),
        color: bg2,
        radius: DesignSystem.borderM,
        border: Border.all(color: bg3.withOpacity(0.3), width: 0.5),
      ),
    ], ca: CrossAxisAlignment.start);
  }

  Widget _infoTile({
    required IconData iconData,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return ListTile(
      leading: icon(iconData, 22, tx2),
      title: text(label, 14, fw4, tx6),
      trailing: text(value, 14, fw6, valueColor ?? tx1),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.space16,
        vertical: 2,
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData iconData,
    Color color,
    VoidCallback onTap,
  ) {
    return inkWell(
      container(
        row([
          icon(iconData, 20, color),
          width(DesignSystem.space12),
          text(label, 15, fw6, color),
        ], ma: MainAxisAlignment.center),
        padding: symmetricV(DesignSystem.space16),
        color: color.withOpacity(0.1),
        radius: DesignSystem.borderM,
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      onTap,
    );
  }
}

