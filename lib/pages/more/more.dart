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
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: tx1, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: text(
          "探索更多",
          18,
          fw9,
          tx1,
          false,
          null,
          fsN,
          TextAlign.start,
          null,
          TextOverflow.clip,
          1.2,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: column([
          height(30),
          _buildBrandHeader(),
          height(40),
          _buildInfoCard(context),
          height(40),
        ]),
      ),
    );
  }

  // 頂部品牌區域
  Widget _buildBrandHeader() {
    return center(
      column([
        container(
          logo(70),
          padding: const EdgeInsets.all(16),
          color: bg2,
          radius: BorderRadius.circular(24),
          border: Border.all(color: so1),
          shadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        height(16),
        text(
          "PCET_CHEINAN0617",
          12,
          fw6,
          tx2,
          false,
          null,
        ),
      ]),
    );
  }

  // 資訊提示卡片
  Widget _buildInfoCard(BuildContext context) {
    return container(
      row([
        CircleAvatar(
          backgroundColor: primary.withOpacity(0.1),
          child: icon(Icons.devices_outlined, 20, primary),
        ),
        width(16),
        expand(
          column(
            [
              text(
                "平台支援說明",
                15,
                fw7,
                tx1,
              ),
              height(4),
              text(
                "目前均提供 Android, Windows, Linux, Web 跨平台版本。",
                13,
                fw4,
                tx2,
                false,
                null,
              ),
            ],
            ca: caS,
          ),
        ),
      ]),
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.all(20),
      color: bg2, // 使用卡片背景色
      radius: BorderRadius.circular(20),
      border: Border.all(color: so1),
    );
  }

  // 產品卡片
  Widget _buildProductCard(Map<String, String> product) {
    return inkWell(
      container(
        row([
          container(
            logo(52),
            radius: BorderRadius.circular(12),
            shadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          width(16),
          expand(
            column(
              [
                text(
                  product['name']!,
                  16,
                  fw7,
                  tx1,
                ),
                height(4),
                text(
                  product['desc']!,
                  12,
                  fw4,
                  tx3,
                ),
              ],
              ca: caS,
            ),
          ),
          icon(
            Icons.open_in_new_outlined,
            18,
            tx3.withOpacity(0.5),
          ),
        ]),
        padding: const EdgeInsets.all(12),
        color: bg2,
        radius: BorderRadius.circular(16),
        border: Border.all(color: so1.withOpacity(0.5)),
      ),
      () => _launchURL(product['url']!),
      radius: BorderRadius.circular(16),
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

  return center(
    // 確保在 AppBar 中垂直置中
    padding(
      const EdgeInsets.only(right: 16.0), // AppBar 右側邊距
      Badge(
        backgroundColor: CommonColors.error,
        smallSize: 8,
        offset: const Offset(2, -2), // 讓紅點稍微向外浮出
        // 使用你的自訂 gestureDetector 包裝點擊事件
        child: gestureDetector(
          container(
            // 文字顏色使用 tx1，並稍微縮小字級配合 AppBar 比例
            text(s, 14, fw6, tx1),
            // 縮小 padding 以適應 AppBar 的高度限制
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            // 完全呼應你 _buildMenuButton (isPrimary = false) 的風格
            color: tx1.withOpacity(0.1),
            radius: BorderRadius.circular(
              12,
            ), // 對齊你的 borderCircular(12)
            border: Border.all(color: tx1.withOpacity(0.2)),
          ),
          onTap,
        ),
      ),
    ),
  );
}
