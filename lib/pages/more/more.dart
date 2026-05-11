import 'package:learnio/base.dart';
import 'package:url_launcher/url_launcher.dart'; // 記得在 pubspec.yaml 加入此套件

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) throw Exception('Could not launch $url');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg1, // 使用主背景色
      appBar: AppBar(
        backgroundColor: bg1,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: tx1, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "探索更多",
          style: TextStyle(
            color: tx1,
            fontWeight: fw9,
            letterSpacing: 1.2,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildBrandHeader(),
            const SizedBox(height: 40),
            _buildInfoCard(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 頂部品牌區域
  Widget _buildBrandHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bg2,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: so1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Image.asset("assets/image/logo/logo.png", height: 70),
          ),
          const SizedBox(height: 16),
          Text(
            "PCET_CHEINAN0617",
            style: TextStyle(
              fontSize: 12,
              color: tx2,
              fontWeight: fw6,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }

  // 資訊提示卡片
  Widget _buildInfoCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg2, // 使用卡片背景色
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: so1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: primary.withOpacity(0.1),
            child: Icon(Icons.devices_rounded, color: primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: caS,
              children: [
                Text(
                  "平台支援說明",
                  style: TextStyle(fontWeight: fw7, fontSize: 15, color: tx1),
                ),
                const SizedBox(height: 4),
                Text(
                  "目前均提供 Android, Windows, Linux, Web 跨平台版本。",
                  style: TextStyle(fontSize: 13, color: tx2, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 產品卡片
  Widget _buildProductCard(Map<String, String> product) {
    return InkWell(
      onTap: () => _launchURL(product['url']!),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: so1.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  product['logo']!,
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: caS,
                children: [
                  Text(
                    product['name']!,
                    style: TextStyle(fontSize: 16, fontWeight: fw7, color: tx1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['desc']!,
                    style: TextStyle(fontSize: 12, color: tx3),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.open_in_new_rounded,
              size: 18,
              color: tx3.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}

Widget more(
  BuildContext context,
  String s, [
  VoidCallback? fn, // 1. 改為可空類型
]) {
  final VoidCallback onTap =
      fn ?? () => launchUrl(Uri.parse("https://chienan0617.github.io/brand"));

  return Center(
    // 確保在 AppBar 中垂直置中
    child: Padding(
      padding: const EdgeInsets.only(right: 16.0), // AppBar 右側邊距
      child: Badge(
        backgroundColor: CommonColors.error,
        smallSize: 8,
        offset: const Offset(2, -2), // 讓紅點稍微向外浮出
        // 使用你的自訂 gestureDetector 包裝點擊事件
        child: gestureDetector(
          Container(
            // 縮小 padding 以適應 AppBar 的高度限制
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              // 完全呼應你 _buildMenuButton (isPrimary = false) 的風格
              color: tx1.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                12,
              ), // 對齊你的 borderCircular(12)
              border: Border.all(color: tx1.withOpacity(0.2)),
            ),
            // 文字顏色使用 tx1，並稍微縮小字級配合 AppBar 比例
            child: text(s, 14, fw6, tx1),
          ),
          onTap,
        ),
      ),
    ),
  );
}
