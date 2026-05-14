import 'package:learnio/base.dart';
// import 'package:web/web.dart' as html;

class DesktopInstallHelper {
  static void onHowToInstallToDesktopButtonPressed(BuildContext context) {
    if (!kIsWeb && !Data.app.get("developer", false)) return;

    // final userAgent = html.window.navigator.userAgent.toLowerCase();
    // final isIos = userAgent.contains('iphone') || userAgent.contains('ipad');
    // final isChrome =
    //     userAgent.contains('crios') || userAgent.contains('chrome');
    // final isSafari = userAgent.contains('safari') && !isChrome;
    // final isAndroid = userAgent.contains('android');

    // 🔥 核心修改：如果是 iOS Safari，直接跳轉到你有「影片介紹」的專屬頁面
    if (kIsWeb || Data.app.get("developer", false)) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const SafariInstallTutorialPage(),
      //   ),
      // );
      // 如果你的 base.dart 裡有封裝好的 pushPage，也可以寫成：
      // pushPage(context, const SafariInstallTutorialPage());
      return; // 直接返回，不再顯示下方的小彈窗
    }

    // 其他平台（Android, 電腦版, iOS Chrome）繼續顯示精緻的 Dialog 提示
    showDialog(
      context: context,
      builder: (ctx) => Material(
        // 🔥 新增：在最外層套上 Material
        type: MaterialType.transparency, // 設為透明，避免干擾你的 BoxDecoration
        child: center(
          padding(
            symmetricH(30),
            container(
              column([
                // 標題列
                row([
                  text("安裝到桌面", 20, fw7, tx1, false, faSg),
                  spacer(),
                  // 這裡的 inkWell 需要 Material 祖先
                  inkWell(
                      icon(Icons.close_outlined, 20, tx3), () => popPage(ctx)),
                ], ma: spB),

                height(24),

                // ... 內容區判斷保持不變
                if ((Platform.isIOS))
                  _buildIosChromeWarning()
                else if (Platform.isAndroid)
                  _buildAndroidGuide()
                else
                  _buildDefaultGuide(),

                height(32),

                // 底部按鈕
                inkWell(
                  container(
                    center(text("我知道了", 16, fw7, tx1p)),
                    width: double.infinity,
                    height: 52,
                    color: primary,
                    radius: borderCircular(14),
                  ),
                  () => popPage(ctx),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  static Widget _buildIosSafariTutorial() => column([
    _guideStep("1", "點擊瀏覽器下方的 '分享' 按鈕"),
    height(16),
    _guideStep("2", "向下滑動並選擇 '加入主畫面'"),
    height(20),
    _buildStepIcon(Icons.ios_share, CommonColors.accentPurple),
  ]);

  static Widget _buildIosChromeWarning() => column([
    _buildStepIcon(Icons.warning_amber_outlined, CommonColors.error),
    height(16),
    center(text("請換用 Safari", 18, fw7, CommonColors.error)),
    height(8),
    center(text("iOS 版 Chrome 不支援安裝，請使用 Safari 開啟。", 14, fw4, tx2)),
  ]);

  static Widget _buildAndroidGuide() => column([
    _guideStep("1", "點擊右上角的選單 ⋮"),
    height(16),
    _guideStep("2", "點擊 '安裝應用程式'"),
    height(20),
    _buildStepIcon(Icons.add_to_home_screen_outlined, CommonColors.accentTeal),
  ]);

  static Widget _buildDefaultGuide() => column([
    center(text("點擊瀏覽器網址列右側的圖標即可安裝應用程式。", 14, fw4, tx2)),
    height(20),
    _buildStepIcon(Icons.laptop_chromebook_outlined, CommonColors.info),
  ]);

  static Widget _guideStep(String num, String desc) => row([
        container(
          center(text(num, 12, fw8, primary)),
          width: 24,
          height: 24,
          color: primary.withOpacity(0.15),
          radius: borderCircular(12),
        ),
    width(12),
    expand(text(desc, 15, fw5, tx1)),
  ]);

  static Widget _buildStepIcon(IconData i, Color c) => center(
        container(
          icon(i, 44, c),
          padding: symmetricAll(24),
          color: c.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
      );
}
