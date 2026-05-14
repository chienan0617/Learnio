import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnio/base.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg1, // 純黑背景
      appBar: AppBar(
        backgroundColor: bg1,
        elevation: 0,
        leading: iconButton(
          icon(Icons.arrow_back_ios_new_outlined, 24, tx1),
          () => popPage(context),
        ),
        title: text("錯誤", 24, fw8, tx1),
        centerTitle: false,
      ),
      body: center(
        padding(
          symmetricH(40),
          column([
            // 使用 ColorFilter 將 SVG 轉為純白色，符合黑白主題
            ColorFiltered(
              colorFilter: ColorFilter.mode(tx1, BlendMode.srcIn),
              child: SvgPicture.asset(
                'assets/image/symbolize/error.svg',
                width: 80,
                height: 80,
              ),
            ),
            box(0, 32),
            text("發生了一些問題", 22, fw8, tx1),
            box(0, 12),
            text("我們無法載入此頁面。請檢查您的網路連線或稍後再試。", 15, fw5, tx2),
            box(0, 48),
            // Threads 風格的寬按鈕
            inkWell(
              container(
                center(text("重試", 16, fw8, tx1p)), // 黑字
                width: double.infinity,
                padding: symmetricV(16),
                color: tx1, // 純白背景
                radius: borderCircular(12),
              ),
              () => popPage(context),
            ),
          ], ca: caC),
        ),
      ),
    );
  }
}

class ErrorSymbolize extends StatelessWidget {
  final String description, subDescription, buttonDescription;
  final VoidCallback? onButtonPressed;
  final bool showButton;

  const ErrorSymbolize({
    super.key,
    this.description = 'Oops, An Error Occurred !',
    this.subDescription = 'Please try again later or contact support.',
    this.showButton = false,
    this.buttonDescription = 'OK',
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    Size s = size(context);

    return center(
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: s.width * 0.75),
        child: Material(
          color: bg1_5, // 與 SavesPage 卡片一致的深灰色
          borderRadius: borderCircular(24), // 略大的圓角展現現代感
          clipBehavior: Clip.antiAlias,
          child: padding(
            symmetric(32, 24),
            column(
              [
                // 圖示
                SvgPicture.asset(
                    'assets/image/symbolize/error.svg',
                    width: 75,
                    height: 75,
                  ),
                box(0, 24),

                // 文字內容
                text(description, 24, fw8, tx1),
                box(0, 8),
                text(
                  subDescription.endsWith(".")
                      ? subDescription
                      : "$subDescription.",
                  16,
                  fw5,
                  tx2,
                ),

                if (showButton) ...[
                  box(0, 32),
                  // Threads 風格按鈕：高對比黑白翻轉
                  inkWell(
                    container(
                      center(
                        text(
                          buttonDescription.toUpperCase(),
                          16,
                          fw8,
                          tx1p,
                        ), // 黑色文字
                      ),
                      width: double.infinity,
                      padding: symmetricV(14),
                      color: tx1, // 白色
                      radius: borderCircular(12),
                    ),
                    onButtonPressed ?? () => Navigator.pop(context),
                  ),
                ],
              ],
              ca: caC,
              ms: mainMi, // MainAxisSize.min 讓彈窗自動適應高度
            ),
          ),
        ),
      ),
    );
  }
}

mixin ErrorWidgets {
  static void showError(
    String description,
    String subDepiction,
    BuildContext ctx,
  ) {
    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (ctx) => ErrorSymbolize(
        description: description,
        subDescription: subDepiction,
        showButton: true,
      ),
    );
  }
}
