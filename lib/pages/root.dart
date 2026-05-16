import 'package:learnio/base.dart';
import 'package:learnio/pages/root/root.dart';
import 'package:learnio/pages/auth/intro_page.dart';
import 'package:learnio/pages/auth/login_page.dart';

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
    AuthController.instance.checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthController.instance;

    // 1. 如果已登入，進入主頁面
    if (auth.isLoggedIn) {
      return _buildApp(const RootPage());
    }

    // 2. 如果未看過導覽，進入導覽頁面
    if (!auth.hasFinishedIntro()) {
      return _buildApp(const IntroPage());
    }

    // 3. 否則進入登入頁面
    return _buildApp(const LoginPage());
  }

  Widget _buildApp(Widget home) {
    return MaterialApp(
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        overscroll: false,
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: darkMode ? Brightness.dark : Brightness.light,
        primaryColor: primary,
        fontFamily: faSg,
      ),
      home: home,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.125)),
          child: child!,
        );
      },
    );
  }
}
