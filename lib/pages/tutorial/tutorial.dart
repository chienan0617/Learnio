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
      body: Stack(
        children: [
          // 背景裝飾圓形 (增加質感)
          // AnimatedPositioned(
          //   duration: const Duration(milliseconds: 800),
          //   top: -100,
          //   right: _currentPage.isEven ? -50 : -150,
          //   child: _buildBackgroundCircle(_pages[_currentPage]['accent'].withOpacity(0.15)),
          // ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: PageView.builder(
                    controller: pageCtrler,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemCount: _pages.length,
                    itemBuilder: (context, index) =>
                        _buildPageItem(_pages[index]),
                  ),
                ),
                _buildBottomBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 頂部跳過
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => finishTutorial(context),
            child: Text(
              "跳過導覽",
              style: TextStyle(color: tx2, fontWeight: fw5),
            ),
          ),
        ],
      ),
    );
  }

  // 頁面主體內容
  Widget _buildPageItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: maC,
        children: [
          // 視覺核心：帶有陰影與漸層的圓角容器
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: bg2,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                // BoxShadow(
                //   color: (item['accent'] as Color).withOpacity(0.2),
                //   blurRadius: 30,
                //   offset: const Offset(0, 20),
                // )
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 幾何裝飾
                // Positioned(
                //   right: -20, top: -20,
                //   child: CircleAvatar(radius: 40, backgroundColor: (item['accent'] as Color).withOpacity(0.1)),
                // ),
                Icon(item['icon'], size: 80, color: item['accent']),
              ],
            ),
          ),
          const SizedBox(height: 60),
          Text(
            item["title"],
            style: TextStyle(
              color: tx1,
              fontSize: 28,
              fontWeight: fw8,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            item["desc"],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tx2,
              fontSize: 16,
              height: 1.6,
              fontWeight: fw4,
            ),
          ),
        ],
      ),
    );
  }

  // 底部控制條
  Widget _buildBottomBar() {
    bool isLast = _currentPage == _pages.length - 1;
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Row(
        mainAxisAlignment: spB,
        children: [
          // 指示器
          Row(
            children: List.generate(_pages.length, (index) {
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
              child: Text(
                isLast ? "開始使用" : "下一步",
                key: ValueKey(isLast),
                style: const TextStyle(fontWeight: fw6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildBackgroundCircle(Color color) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
      ),
    );
  }
}
