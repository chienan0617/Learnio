import 'package:learnio/base.dart';
import 'package:learnio/core/install.dart';
import 'package:learnio/pages/root/root.dart';

mixin TutorialPageIntroductionCtrler {
  final PageController pageCtrler = PageController();

  static bool isTutored() => true; //Data.app.get<bool>("tutored");

  static List<Map<String, dynamic>> getPagesData() {
    return [
      {
        "title": "歡迎加入 Alpha 測試版",
        "desc": "內容很寒酸我知道",
        "image": "assets/icon/icon.webp", // 使用者指定的 App Icon
        "isNetwork": false,
        "accent": primary,
      },
    ];
  }

  void onNextStep(int currentIndex, int total, BuildContext context) {
    if (currentIndex < total - 1) {
      pageCtrler.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutSine,
      );
    } else {
      finishTutorial(context);
    }
  }

  void finishTutorial(BuildContext context) {
    Data.app.put("tutored", true); // 標記已完成導覽
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RootPage()),
    );

    DesktopInstallHelper.onHowToInstallToDesktopButtonPressed(context);
    // HomePageTaskDisplayFuncWidget.showUserGuide(context);
  }
}
