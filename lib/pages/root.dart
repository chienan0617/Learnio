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
    Rebuild.register("main", () => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        overscroll: false, // 不顯示 overscroll 效果
      ),
      // color: primary,
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: darkMode ? Brightness.dark : Brightness.light,
        primaryColor: primary,

        // scaffoldBackgroundColor: darkMode ? background1 : background2,
        // canvasColor: darkMode ? background3 : background4,
        // textTheme: TextTheme(
        //   // bodyText1: TextStyle(color: tc),
        //   // bodyText2: TextStyle(color: tc2),
        // ),
      ),
      home: TutorialPageIntroductionCtrler.isTutored()
          ? const RootPage()
          : const TutorialIntroductionPage(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
