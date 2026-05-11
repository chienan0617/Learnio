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
          icon(Icons.arrow_back_ios_new_rounded, 20, tx1),
          () => Navigator.pop(context),
        ),
        title: textD("更多功能", 18, fw7, tx1),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: caS,
          children: [
            _buildStatisticsSection(),
            _buildSectionTitle("數據與同步"),
            _buildMenuCard([
              _menuItem(
                Icons.cloud_done_rounded,
                "雲端備份",
                "最後同步：10分鐘前",
                Colors.blue,
              ),
              _menuItem(
                Icons.analytics_rounded,
                "生產力報告",
                "查看您的任務完成趨勢",
                Colors.orange,
              ),
            ]),
            _buildSectionTitle("工作空間"),
            _buildMenuCard([
              _menuItem(Icons.archive_rounded, "檔案櫃", "已封存的筆記與清單", Colors.teal),
              _menuItem(
                Icons.delete_outline_rounded,
                "回收站",
                "最近刪除的項目",
                Colors.redAccent,
              ),
            ]),
            _buildSectionTitle("其他"),
            _buildMenuCard([
              _menuItem(
                Icons.star_outline_rounded,
                "給個好評",
                "支持我們的開發工作",
                Colors.amber,
              ),
              _menuItem(
                Icons.share_rounded,
                "分享給朋友",
                "讓更多人體驗極簡效率",
                Colors.indigo,
              ),
            ]),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 頂部統計數據卡片
  Widget _buildStatisticsSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: const AssetImage('assets/images/pattern.png'), // 可選：加入淡紋理
          opacity: 0.1,
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: spB,
        children: [
          _statItem("128", "筆記總數"),
          Container(width: 1, height: 40, color: Colors.white24),
          _statItem("12", "進行中"),
          Container(width: 1, height: 40, color: Colors.white24),
          _statItem("85%", "完成率"),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        textD(value, 24, fw8, Colors.white),
        const SizedBox(height: 4),
        textD(label, 12, fw4, Colors.white.withOpacity(0.8)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      child: textD(title, 14, fw7, tx2),
    );
  }

  Widget _buildMenuCard(List<Widget> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: bg2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: items),
    );
  }

  Widget _menuItem(IconData icon, String title, String subtitle, Color color) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: textD(title, 16, fw6, tx1),
      subtitle: textD(subtitle, 12, fw4, tx2),
      trailing: Icon(Icons.chevron_right_rounded, color: tx3, size: 20),
      onTap: () {},
    );
  }
}
