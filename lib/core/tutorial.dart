import 'package:learnio/base.dart';
import 'package:learnio/core/install.dart';
import 'package:learnio/pages/root/root.dart';

mixin TutorialPageIntroductionCtrler {
  final PageController pageCtrler = PageController();

  static bool isTutored() => Data.app.get<bool>("tutored", false);

  static List<Map<String, dynamic>> getPagesData() {
    return [
      {
        "title": "歡迎來到 Learnio",
        "desc": "你的個人 AI 學習助手，幫助你更高效地掌握知識。",
        "icon": Icons.auto_awesome_outlined,
        "accent": primary,
      },
      {
        "title": "AI 智慧對話",
        "desc": "隨時向 AI 提問，獲取詳細的解釋、範例與學習建議。",
        "icon": Icons.chat_bubble_outline_rounded,
        "accent": Colors.blueAccent,
      },
      {
        "title": "專案分類管理",
        "desc": "將對話整理到不同專案中，讓學習記錄條理清晰。",
        "icon": Icons.folder_outlined,
        "accent": Colors.orangeAccent,
      },
      {
        "title": "收藏核心知識",
        "desc": "點擊書籤收藏重要的訊息，隨時回顧精華內容。",
        "icon": Icons.bookmark_border_rounded,
        "accent": Colors.redAccent,
      },
      {
        "title": "個人學習庫",
        "desc": "將 AI 的回答儲存為筆記，打造專屬於你的知識地圖。",
        "icon": Icons.school_outlined,
        "accent": Colors.greenAccent,
      },
      {
        "title": "完全個性化",
        "desc": "切換深淺模式，選擇你喜愛的模型，享受極簡的學習體驗。",
        "icon": Icons.settings_suggest_outlined,
        "accent": Colors.purpleAccent,
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
    
    // 重建 Main 以切換 home
    rebuild('main');

    DesktopInstallHelper.onHowToInstallToDesktopButtonPressed(context);
  }
}
