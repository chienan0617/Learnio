import 'package:learnio/base.dart';

class PageNavigation {
  @registerFirst
  static String keyName = 'navigation-bar-index';
  static int currentIndex = 0;//Data.app.get(keyName);
  static final Widget _defaultPage = box();

  static List<Widget> pages = [
    _defaultPage,
    _defaultPage,
    _defaultPage,
    _defaultPage,
  ];

  static void onChange(int newValue) {
    // Data.app.put(keyName, newValue);
    currentIndex = newValue;
    SourcePath([("root")]).callAll();
  }

  static Widget getPage() {
    return pages[currentIndex];
    // return CalendarPage();
  }

  static Widget getPageByIndex(int index) {
    if (index < 0 || index >= pages.length) {
      throw IndexOutOfBoundError();
    }

    return pages[index];
  }
}
