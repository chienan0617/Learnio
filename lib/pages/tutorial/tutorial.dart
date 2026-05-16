import 'package:learnio/base.dart';

class TutorialIntroductionPage extends StatefulWidget {
  const TutorialIntroductionPage({super.key});

  @override
  State<TutorialIntroductionPage> createState() =>
      _TutorialIntroductionPageState();
}

class _TutorialIntroductionPageState extends State<TutorialIntroductionPage>
    with TutorialPageIntroductionCtrler {
  int _currentPage = 0;
  final List<Map<String, dynamic>> _pages =
      TutorialPageIntroductionCtrler.getPagesData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg1,
      body: stack([
        // 背景裝飾圓形 (增加質感)
        // AnimatedPositioned(
        //   duration: const Duration(milliseconds: 800),
        //   top: -100,
        //   right: _currentPage.isEven ? -50 : -150,
        //   child: _buildBackgroundCircle(_pages[_currentPage]['accent'].withOpacity(0.15)),
        // ),
        SafeArea(
          child: column([
            _buildHeader(),
            expand(
              PageView.builder(
                controller: pageCtrler,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, index) => _buildPageItem(_pages[index]),
              ),
            ),
            _buildBottomBar(),
          ]),
        ),
      ]),
    );
  }

  // 頂部跳過
  Widget _buildHeader() {
    return padding(
      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      row([
        TextButton(
          onPressed: () => finishTutorial(context),
          child: text("跳過導覽", 14, fw5, tx2),
        ),
      ], ma: MainAxisAlignment.end),
    );
  }

  // 頁面主體內容
  Widget _buildPageItem(Map<String, dynamic> item) {
    return padding(
      const EdgeInsets.symmetric(horizontal: 40),
      column([
        // 視覺核心：帶有陰影與漸層的圓角容器
        container(
          stack([
            // 幾何裝飾
            // Positioned(
            //   right: -20, top: -20,
            //   child: CircleAvatar(radius: 40, backgroundColor: (item['accent'] as Color).withOpacity(0.1)),
            // ),
            center(
              item['icon'] is IconData
                  ? icon(item['icon'], 80, item['accent'])
                  : item['icon'],
            ),
          ]),
          width: 200,
          height: 200,
          color: bg2,
          radius: BorderRadius.circular(40),
          shadow: [
            // BoxShadow(
            //   color: (item['accent'] as Color).withOpacity(0.2),
            //   blurRadius: 30,
            //   offset: const Offset(0, 20),
            // )
          ],
        ),
        height(60),
        text(
          item["title"],
          28,
          fw8,
          tx1,
          false,
          null,
          fsN,
          TextAlign.start,
          null,
          TextOverflow.clip,
          1.2,
        ),
        height(20),
        text(
          item["desc"],
          16,
          fw4,
          tx2,
          false,
          null,
          fsN,
          TextAlign.center,
          null,
          TextOverflow.clip,
          1.6,
        ),
      ], ma: maC),
    );
  }

  // 底部控制條
  Widget _buildBottomBar() {
    bool isLast = _currentPage == _pages.length - 1;
    return padding(
      const EdgeInsets.all(40),
      row(
        [
          // 指示器
          row(
            List.generate(_pages.length, (index) {
              bool active = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 8),
                height: 6,
                width: active ? 24 : 6,
                decoration: BoxDecoration(
                  color: active ? (isLast ? primary : tx1) : bg5,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),

          // 下一步按鈕
          ElevatedButton(
            onPressed: () => onNextStep(_currentPage, _pages.length, context),
            style: ElevatedButton.styleFrom(
              backgroundColor: isLast ? primary : bg2,
              foregroundColor: isLast ? tx1p : tx1,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: isLast
                    ? BorderSide.none
                    : BorderSide(color: so1, width: 1),
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: text(
                isLast ? "開始使用" : "下一步",
                14,
                fw6,
                null,
                false,
                null,
                fsN,
                TextAlign.start,
                null,
                TextOverflow.clip,
                null,
                ValueKey(isLast),
              ),
            ),
          ),
        ],
        ma: spB,
        ca: caC,
      ),
    );
  }

  // ignore: unused_element
  Widget _buildBackgroundCircle(Color color) {
    return container(
      const SizedBox.shrink(),
      width: 300,
      height: 300,
      shape: BoxShape.circle,
      gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
    );
  }
}
