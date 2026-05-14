import 'package:learnio/base.dart';
import 'package:learnio/pages/root/root.dart';
import 'package:learnio/pages/tutorial/tutorial.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    Rebuild.register('main', () => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    // 檢查是否已看過導覽
    final bool isTutored = Data.app.get<bool>("tutored", false);

    return MaterialApp(
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        overscroll: false,
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: darkMode ? Brightness.dark : Brightness.light,
        primaryColor: primary,
      ),
      home: isTutored ? const RootPage() : const TutorialIntroductionPage(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
