import 'package:learnio/base.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      backgroundColor: bg1, // 使用主背景色
      child: SafeArea(
        child: Column(
          crossAxisAlignment: caS,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),

            // 選項列表
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _sidebarItem(Icons.home_rounded, '主頁', 0, () {}),
                  _sidebarItem(Icons.settings_rounded, '應用設置', 1, () {}),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    child: Divider(color: so1.withOpacity(0.5), thickness: 1),
                  ),

                  _sidebarItem(Icons.info_outline_rounded, '關於', 2, showInfo),
                  _sidebarItem(Icons.bug_report_rounded, '除錯', 3, () {
                    // ErrorWidgets.showError(
                    //   '哈囉你好',
                    //   '目前版本：${System.version}',
                    //   context,
                    // );
                  }),
                ],
              ),
            ),

            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // 精緻的頂部品牌區
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: caS,
        children: [
          // 品牌 Logo 容器
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bg2,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/icon/icon.webp',
                width: 48,
                height: 48,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Daily Keep",
            style: TextStyle(
              color: tx1,
              fontSize: 22,
              fontWeight: fw8,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                "By PCET_CHIENAN0617",
                style: TextStyle(color: tx2, fontSize: 13, fontWeight: fw4),
              ),
              const SizedBox(width: 8),
              buildAlphaTag(),
            ],
          ),
        ],
      ),
    );
  }

  // Web Alpha 標籤

  // 自定義選單項
  Widget _sidebarItem(
    IconData icon,
    String title,
    int index,
    VoidCallback onTap,
  ) {
    bool isSelected = _selectedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () {
          setState(() => _selectedIndex = index);
          Navigator.pop(context);
          onTap();
        },
        leading: Icon(icon, color: isSelected ? primary : tx2, size: 24),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? tx1 : tx2,
            fontWeight: isSelected ? fw7 : fw5,
            fontSize: 15,
          ),
        ),
        trailing: isSelected
            ? Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // 底部版本資訊
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: bg2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.vibration_rounded,
              size: 14,
              color: tx2.withOpacity(0.5),
            ),
            const SizedBox(width: 8),
            Text(
              'Version ${System.version}',
              style: TextStyle(
                color: tx2.withOpacity(0.6),
                fontSize: 11,
                fontWeight: fw5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showInfo() {
    showAboutDialog(
      context: context,
      applicationIcon: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset('assets/icon/icon.webp', width: 60, height: 60),
        ),
      ),
      applicationName: 'Notes and Todos',
      applicationLegalese: '© 2025 CAStudio',
      applicationVersion: System.version,
    );
  }
}

Widget buildAlphaTag() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.orangeAccent.withOpacity(0.1),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(
        color: Colors.orangeAccent.withOpacity(0.3),
        width: 0.5,
      ),
    ),
    child: const Text(
      "ALPHA",
      style: TextStyle(
        color: Colors.orangeAccent,
        fontSize: 9,
        fontWeight: fw7,
      ),
    ),
  );
}

Widget buildAlphaBanner(Widget c) {
  return Banner(
    message: "ALPHA",
    location: BannerLocation.topEnd,
    color: Colors.orangeAccent,
    child: c,
  );
}
