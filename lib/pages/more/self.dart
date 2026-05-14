import 'package:learnio/base.dart';

class SelfPageNotEnable extends StatelessWidget {
  const SelfPageNotEnable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg1,
      appBar: AppBar(
        backgroundColor: bg1,
        elevation: 0,
        leading: iconButton(
          icon(Icons.arrow_back_ios_new_outlined, 20, tx1),
          () => Navigator.pop(context),
        ),
        title: textD("更多功能", 18, fw7, tx1),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: column([
          _buildStatisticsSection(),
          _buildSectionTitle("數據與同步"),
          _buildMenuCard([
            _menuItem(
              Icons.cloud_done_outlined,
              "雲端備份",
              "最後同步：10分鐘前",
              Colors.blue,
            ),
            _menuItem(
              Icons.analytics_outlined,
              "生產力報告",
              "查看您的任務完成趨勢",
              Colors.orange,
            ),
          ]),
          _buildSectionTitle("工作空間"),
          _buildMenuCard([
            _menuItem(Icons.archive_outlined, "檔案櫃", "已封存的筆記與清單", Colors.teal),
            _menuItem(
              Icons.delete_outlined,
              "回收站",
              "最近刪除的項目",
              Colors.redAccent,
            ),
          ]),
          _buildSectionTitle("其他"),
          _buildMenuCard([
            _menuItem(Icons.star_outlined, "給個好評", "支持我們的開發工作", Colors.amber),
            _menuItem(
              Icons.share_outlined,
              "分享給朋友",
              "讓更多人體驗極簡效率",
              Colors.indigo,
            ),
          ]),
          height(40),
        ], ca: caS),
      ),
    );
  }

  // 頂部統計數據卡片
  Widget _buildStatisticsSection() {
    return container(
      row([
        _statItem("128", "筆記總數"),
        container(
          const SizedBox.shrink(),
          width: 1,
          height: 40,
          color: Colors.white24,
        ),
        _statItem("12", "進行中"),
        container(
          const SizedBox.shrink(),
          width: 1,
          height: 40,
          color: Colors.white24,
        ),
        _statItem("85%", "完成率"),
      ], ma: spB),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      color: primary,
      radius: BorderRadius.circular(24),
      image: const DecorationImage(
        image: AssetImage('assets/images/pattern.png'), // 可選：加入淡紋理
        opacity: 0.1,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return column([
      textD(value, 24, fw8, Colors.white),
      height(4),
      textD(label, 12, fw4, Colors.white.withOpacity(0.8)),
    ]);
  }

  Widget _buildSectionTitle(String title) {
    return padding(
      const EdgeInsets.fromLTRB(24, 20, 24, 12),
      textD(title, 14, fw7, tx2),
    );
  }

  Widget _buildMenuCard(List<Widget> items) {
    return container(
      column(items),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: bg2,
      radius: BorderRadius.circular(20),
    );
  }

  Widget _menuItem(
    IconData iconData,
    String title,
    String subtitle,
    Color color,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: container(
        icon(iconData, 22, color),
        padding: const EdgeInsets.all(8),
        color: color.withOpacity(0.1),
        radius: BorderRadius.circular(10),
      ),
      title: textD(title, 16, fw6, tx1),
      subtitle: textD(subtitle, 12, fw4, tx2),
      trailing: icon(Icons.chevron_right_outlined, 20, tx3),
      onTap: () {},
    );
  }
}
