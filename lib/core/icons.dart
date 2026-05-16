import 'package:learnio/base.dart';
import 'package:string_to_icon/string_to_icon.dart';

class AppIcons {
  static IconData getIcon(String name) {
    return IconMapper.getIconData(name);
  }
}

IconData iconData(String name) => AppIcons.getIcon(name);
