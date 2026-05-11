import 'package:learnio/base.dart';
import 'package:learnio/pages/root/side_bar.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
    Rebuild.register("root", () => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      backgroundColor: bg1,
      body: box(),
      // ignore: dead_code
      bottomNavigationBar: true
          ? box()
          // ignore: dead_code
          : Container(
              decoration: BoxDecoration(
                color: bg3,
                border: Border(
                  top: BorderSide(
                    color: tx2, // 或 tx2.withOpacity(0.2)
                    width: 0.25,
                  ),
                ),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  items: [
                    item(Icons.home, Icons.home, "Home", 0),
                    item(
                      Icons.calendar_today,
                      Icons.calendar_today,
                      "Calendar",
                      1,
                    ),
                    item(
                      Icons.assistant_outlined,
                      Icons.assistant_outlined,
                      "AI Agent",
                      2,
                    ),
                    item(Icons.person, Icons.person, "Person", 3),
                  ],
                  elevation: 0,
                  backgroundColor: bg1,
                  selectedFontSize: 12,
                  unselectedFontSize: 12,
                  selectedItemColor: primary,
                  unselectedItemColor: tx2,
                  selectedLabelStyle: TextStyle(color: tx1, fontFamily: faSg),
                  onTap: PageNavigation.onChange,
                  currentIndex: PageNavigation.currentIndex,
                  type: BottomNavigationBarType.fixed,
                ),
              ),
            ),
    );
  }

  BottomNavigationBarItem item(
    IconData icon,
    IconData iconSelected,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          Icon(
            PageNavigation.currentIndex == index ? iconSelected : icon,
            size: 26,
          ),
          height(2.5),
          // height(5),
        ],
      ),
      label: label, //Language.word(label),
    );
  }
}
