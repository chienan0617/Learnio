import 'package:device_preview/device_preview.dart';

import 'base.dart';
import 'pages/root.dart';

void main() async {
  await Initialize.setupApp();
  runApp(Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) => kDebugMode
      ? DevicePreview(builder: (_) => const MainPage())
      : const MainPage();
}
