import 'package:learnio/base.dart';
import 'package:learnio/pages/auth/login_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _introData = [
    {
      "title": "Learnio AI",
      "subtitle": "你的個人化學習伴侶",
      "desc": "透過與 AI 對話，以專案化的方式掌握任何領域的知識。",
      "icon": Icons.auto_awesome_rounded,
      "color": primary,
    },
    {
      "title": "深度學習",
      "subtitle": "不只是問答，更是成長",
      "desc": "AI 會根據你的學習進度，提供量身定制的建議與測驗。",
      "icon": Icons.school_rounded,
      "color": Colors.orangeAccent,
    },
    {
      "title": "知識管理",
      "subtitle": "讓資訊變為智慧",
      "desc": "輕鬆將對話整理為專案，並收藏核心知識點以便回顧。",
      "icon": Icons.folder_special_rounded,
      "color": Colors.blueAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg1,
      body: SafeArea(
        child: column([
          expand(
            PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemCount: _introData.length,
              itemBuilder: (context, index) => _buildPage(_introData[index]),
            ),
          ),
          _buildBottomSection(),
        ]),
      ),
    );
  }

  Widget _buildPage(Map<String, dynamic> data) {
    return padding(
      const EdgeInsets.symmetric(horizontal: 40),
      column([
        center(
          container(
            center(icon(data['icon'], 80, data['color'])),
            width: 180,
            height: 180,
            radius: DesignSystem.borderXL,
            color: bg2,
            shadow: DesignSystem.shadowSoft,
          ),
        ),
        height(60),
        text(data['title'], 32, fw8, tx1, false, null, fsN, TextAlign.center),
        height(8),
        text(data['subtitle'], 18, fw6, data['color'], false, null, fsN, TextAlign.center),
        height(24),
        text(data['desc'], 16, fw4, tx2, false, null, fsN, TextAlign.center, null, TextOverflow.clip, null),
      ], ma: maC, ca: caC),
    );
  }

  Widget _buildBottomSection() {
    bool isLast = _currentIndex == _introData.length - 1;
    return padding(
      const EdgeInsets.all(40),
      row([
        // Indicators
        row(List.generate(_introData.length, (index) {
          bool active = index == _currentIndex;
          return AnimatedContainer(
            duration: DesignSystem.animNormal,
            margin: const EdgeInsets.only(right: 8),
            height: 6,
            width: active ? 24 : 6,
            decoration: BoxDecoration(
              color: active ? primary : bg5,
              borderRadius: borderCircular(3),
            ),
          );
        })),
        
        // Next/Start Button
        inkWell(
          container(
            center(
              text(
                isLast ? "即刻開始" : "下一步",
                14,
                fw7,
                isLast ? tx1p : tx1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            radius: DesignSystem.borderL,
            color: isLast ? primary : bg2,
          ),
          () {
            if (isLast) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
            } else {
              _pageController.nextPage(duration: DesignSystem.animNormal, curve: Curves.easeInOut);
            }
          },
        ),
      ], ma: spB),
    );
  }
}
